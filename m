Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2J2Pcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:32:42 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:54293 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752717Ab2J2Pck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:32:40 -0400
Message-ID: <508EA197.5010206@xenotime.net>
Date: Mon, 29 Oct 2012 08:32:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: linux-pm@vger.kernel.org, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next PATCH] PM / devfreq: documentation cleanups for devfreq
 header
References: <1351515743-23411-1-git-send-email-nm@ti.com>
In-Reply-To: <1351515743-23411-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 06:02 AM, Nishanth Menon wrote:

> struct parameters need to have ':' in documentation for
> scripts/kernel-doc to parse appropriately.
> 
> Fix the errors reported by:
> ./scripts/kernel-doc include/linux/devfreq.h >/dev/null
> 
> Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> Applies on
> linux-next                e083feb Merge branch 'acpi-next' into linux-next
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> 
>  include/linux/devfreq.h |   54 +++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 7e2e2ea..1461fb2 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -25,12 +25,12 @@ struct devfreq;
>   * struct devfreq_dev_status - Data given from devfreq user device to
>   *			     governors. Represents the performance
>   *			     statistics.
> - * @total_time		The total time represented by this instance of
> + * @total_time:		The total time represented by this instance of
>   *			devfreq_dev_status
> - * @busy_time		The time that the device was working among the
> + * @busy_time:		The time that the device was working among the
>   *			total_time.
> - * @current_frequency	The operating frequency.
> - * @private_data	An entry not specified by the devfreq framework.
> + * @current_frequency:	The operating frequency.
> + * @private_data:	An entry not specified by the devfreq framework.
>   *			A device and a specific governor may have their
>   *			own protocol with private_data. However, because
>   *			this is governor-specific, a governor using this
> @@ -54,21 +54,21 @@ struct devfreq_dev_status {
>  
>  /**
>   * struct devfreq_dev_profile - Devfreq's user device profile
> - * @initial_freq	The operating frequency when devfreq_add_device() is
> + * @initial_freq:	The operating frequency when devfreq_add_device() is
>   *			called.
> - * @polling_ms		The polling interval in ms. 0 disables polling.
> - * @target		The device should set its operating frequency at
> + * @polling_ms:		The polling interval in ms. 0 disables polling.
> + * @target:		The device should set its operating frequency at
>   *			freq or lowest-upper-than-freq value. If freq is
>   *			higher than any operable frequency, set maximum.
>   *			Before returning, target function should set
>   *			freq at the current frequency.
>   *			The "flags" parameter's possible values are
>   *			explained above with "DEVFREQ_FLAG_*" macros.
> - * @get_dev_status	The device should provide the current performance
> + * @get_dev_status:	The device should provide the current performance
>   *			status to devfreq, which is used by governors.
> - * @get_cur_freq	The device should provide the current frequency
> + * @get_cur_freq:	The device should provide the current frequency
>   *			at which it is operating.
> - * @exit		An optional callback that is called when devfreq
> + * @exit:		An optional callback that is called when devfreq
>   *			is removing the devfreq object due to error or
>   *			from devfreq_remove_device() call. If the user
>   *			has registered devfreq->nb at a notifier-head,
> @@ -87,14 +87,14 @@ struct devfreq_dev_profile {
>  
>  /**
>   * struct devfreq_governor - Devfreq policy governor
> - * @name		Governor's name
> - * @get_target_freq	Returns desired operating frequency for the device.
> + * @name:		Governor's name
> + * @get_target_freq:	Returns desired operating frequency for the device.
>   *			Basically, get_target_freq will run
>   *			devfreq_dev_profile.get_dev_status() to get the
>   *			status of the device (load = busy_time / total_time).
>   *			If no_central_polling is set, this callback is called
>   *			only with update_devfreq() notified by OPP.
> - * @event_handler       Callback for devfreq core framework to notify events
> + * @event_handler:      Callback for devfreq core framework to notify events
>   *                      to governors. Events include per device governor
>   *                      init and exit, opp changes out of devfreq, suspend
>   *                      and resume of per device devfreq during device idle.
> @@ -110,23 +110,23 @@ struct devfreq_governor {
>  
>  /**
>   * struct devfreq - Device devfreq structure
> - * @node	list node - contains the devices with devfreq that have been
> + * @node:	list node - contains the devices with devfreq that have been
>   *		registered.
> - * @lock	a mutex to protect accessing devfreq.
> - * @dev		device registered by devfreq class. dev.parent is the device
> + * @lock:	a mutex to protect accessing devfreq.
> + * @dev:	device registered by devfreq class. dev.parent is the device
>   *		using devfreq.
> - * @profile	device-specific devfreq profile
> - * @governor	method how to choose frequency based on the usage.
> - * @nb		notifier block used to notify devfreq object that it should
> + * @profile:	device-specific devfreq profile
> + * @governor:	method how to choose frequency based on the usage.
> + * @nb:		notifier block used to notify devfreq object that it should
>   *		reevaluate operable frequencies. Devfreq users may use
>   *		devfreq.nb to the corresponding register notifier call chain.
> - * @work	delayed work for load monitoring.
> - * @previous_freq	previously configured frequency value.
> - * @data	Private data of the governor. The devfreq framework does not
> + * @work:	delayed work for load monitoring.
> + * @previous_freq:	previously configured frequency value.
> + * @data:	Private data of the governor. The devfreq framework does not
>   *		touch this.
> - * @min_freq	Limit minimum frequency requested by user (0: none)
> - * @max_freq	Limit maximum frequency requested by user (0: none)
> - * @stop_polling	 devfreq polling status of a device.
> + * @min_freq:	Limit minimum frequency requested by user (0: none)
> + * @max_freq:	Limit maximum frequency requested by user (0: none)
> + * @stop_polling:	 devfreq polling status of a device.
>   *
>   * This structure stores the devfreq information for a give device.
>   *
> @@ -186,9 +186,9 @@ extern const struct devfreq_governor devfreq_simple_ondemand;
>  /**
>   * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
>   *	and devfreq_add_device
> - * @ upthreshold	If the load is over this value, the frequency jumps.
> + * @upthreshold:	If the load is over this value, the frequency jumps.
>   *			Specify 0 to use the default. Valid value = 0 to 100.
> - * @ downdifferential	If the load is under upthreshold - downdifferential,
> + * @downdifferential:	If the load is under upthreshold - downdifferential,
>   *			the governor may consider slowing the frequency down.
>   *			Specify 0 to use the default. Valid value = 0 to 100.
>   *			downdifferential < upthreshold must hold.



-- 
~Randy
