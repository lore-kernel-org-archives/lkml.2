Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab2KXA1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2KXA1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:01 -0500
Date: Fri, 23 Nov 2012 22:26:55 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 011/171] ptp: update adjfreq callback description
Message-ID: <20121124002654.GB12014@herton-Z68MA-D2H-B3>
References: <20121122004033.298367941@linuxfoundation.org>
 <20121122004034.452636003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122004034.452636003@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:39:17PM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> commit 87f4d7c1d36f44b0822053b7e5dedc31fdd0ab99 upstream.
> 
> This patch updates the adjfreq callback description to include a note that the
> delta in ppb is always relative to the base frequency, and not to the current
> frequency of the hardware clock.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> CC: Richard Cochran <richard.cochran@gmail.com>
> CC: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  include/linux/ptp_clock_kernel.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -50,7 +50,8 @@ struct ptp_clock_request {
>   * clock operations
>   *
>   * @adjfreq:  Adjusts the frequency of the hardware clock.
> - *            parameter delta: Desired period change in parts per billion.
> + *            parameter delta: Desired frequency offset from nominal frequency
> + *            in parts per billion
>   *
>   * @adjtime:  Shifts the time of the hardware clock.
>   *            parameter delta: Desired change in nanoseconds.
> 

This was marked for only 3.5 or later on the original changelog:
"CC: stable@vger.kernel.org [v3.5+]"

-- 
[]'s
Herton
