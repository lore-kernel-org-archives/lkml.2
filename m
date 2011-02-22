Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1BVIma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:42:30 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:50831 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1BVIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:42:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FwsdNZft9y4ztKVHWvlqZ7D9tZth9j2YeI+xrurErtf4mMndUKQihVrJ2eIbHCSElJ
         z7vms+AVCABnEeExkkJwt5GjYGWDFPblbg57BqgvVy7M//qQVTplqjjtoZlfrfaTxmlP
         GH6ixCEjQy703c0Wbv3ISbVlcJgS7fhOpg6vQ=
Message-ID: <4D6376F0.4020200@gmail.com>
Date: Tue, 22 Feb 2011 09:42:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <20110222053932.GB21903@gamma.logic.tuwien.ac.at>
In-Reply-To: <20110222053932.GB21903@gamma.logic.tuwien.ac.at>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 06:39 AM, Norbert Preining wrote:
> Hi everyone,
> 
> sorry for late reply, was night over here in Japan.
> 
> On Mo, 21 Feb 2011, Rajiv Andrade wrote:
>> Norbert, can 'cat /sys/devices/pnp0/00\:0*/timeouts' and send the output?
> 
> I don't have any of these files:
> $ ls /sys/devices/pnp0/*
> /sys/devices/pnp0/uevent
> 
> /sys/devices/pnp0/00:00:
> id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:01:
> driver	firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:02:
> firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:03:
> driver	       id     options  resources  subsystem
> firmware_node  nvram  power    rtc	  uevent
> 
> /sys/devices/pnp0/00:04:
> firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:05:
> firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:06:
> firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:07:
> driver	firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:08:
> driver	firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:09:
> firmware_node  id  options  power  resources  subsystem  uevent
> 
> /sys/devices/pnp0/00:0a:
> active	driver	       id	owned  pubek	  temp_deactivated
> cancel	enabled        misc	pcrs   resources  uevent
> caps	firmware_node  options	power  subsystem
> 
> /sys/devices/pnp0/power:
> async		      runtime_status	      wakeup_count
> autosuspend_delay_ms  runtime_suspended_time  wakeup_hit_count
> control		      runtime_usage	      wakeup_last_time_ms
> runtime_active_kids   wakeup		      wakeup_max_time_ms
> runtime_active_time   wakeup_active	      wakeup_total_time_ms
> runtime_enabled       wakeup_active_count
> $
> 
> running git kernel 6f576d57f1 (were the commit is reverted)

Ok, run some older kernel where this is not reverted (.38-rc5, 2.6.37.1)
or revert the revert :).

regards,
-- 
js
