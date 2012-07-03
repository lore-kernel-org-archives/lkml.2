Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2GCRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:16:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab2GCRQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:16:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Oskar Schirmer" <oskar@scara.com>
Subject: Re: [PATCH 1/2] Documentation: fix typos in power management description
Date: Tue, 3 Jul 2012 19:21:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: "Rob Landley" <rob@landley.net>, linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "David Brownell" <david-b@pacbell.net>,
        "Alan Stern" <stern@rowland.harvard.edu>
References: <1341307645-15135-1-git-send-email-oskar@scara.com>
In-Reply-To: <1341307645-15135-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031921.58084.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 03, 2012, Oskar Schirmer wrote:
> Just two missing characters.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>

Queued up for inclusion into v3.6 in the pm-doc branch of the linux-pm.git tree.

Thanks,
Rafael


> ---
>  Documentation/power/devices.txt |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/power/devices.txt b/Documentation/power/devices.txt
> index 872815c..504dfe4 100644
> --- a/Documentation/power/devices.txt
> +++ b/Documentation/power/devices.txt
> @@ -583,9 +583,10 @@ for the given device during all power transitions, instead of the respective
>  subsystem-level callbacks.  Specifically, if a device's pm_domain pointer is
>  not NULL, the ->suspend() callback from the object pointed to by it will be
>  executed instead of its subsystem's (e.g. bus type's) ->suspend() callback and
> -anlogously for all of the remaining callbacks.  In other words, power management
> -domain callbacks, if defined for the given device, always take precedence over
> -the callbacks provided by the device's subsystem (e.g. bus type).
> +analogously for all of the remaining callbacks.  In other words, power
> +management domain callbacks, if defined for the given device, always take
> +precedence over the callbacks provided by the device's subsystem (e.g. bus
> +type).
>  
>  The support for device power management domains is only relevant to platforms
>  needing to use the same device driver power management callbacks in many
> @@ -598,7 +599,7 @@ it into account in any way.
>  Device Low Power (suspend) States
>  ---------------------------------
>  Device low-power states aren't standard.  One device might only handle
> -"on" and "off, while another might support a dozen different versions of
> +"on" and "off", while another might support a dozen different versions of
>  "on" (how many engines are active?), plus a state that gets back to "on"
>  faster than from a full "off".
>  
> 

