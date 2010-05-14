Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0ENHPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:15:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60747 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab0ENHPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NVdQBxut9Tnt3ooJjEkEWw7P3PYG41YqnvAzUbpdDm60ozfgMW3LeuUOWQsdHzIQ4B
         ktjpubaJj6lwH56L9y2UfPXe8RNMoMFZ6xQR5Ze4zK5qiJyCyPA8NNE2zQoMyuZp/jow
         HPtAcsy2IZcZRZioJ3/gXOgl9urTVEq6VRNIU=
Date: Fri, 14 May 2010 15:19:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
Message-ID: <20100514071905.GB5612@cr0.nay.redhat.com>
References: <4BEC4B0D.8010102@example.com>
 <4BEC4CD6.6090402@example.com>
 <4BEC52C0.1000403@xenotime.net>
 <4BECACC3.3020309@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BECACC3.3020309@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 03:52:03AM +0200, Piotr Hosowicz wrote:
>On 13.05.2010 21:28, Randy Dunlap wrote:
>>Piotr Hosowicz wrote:
>>>On 13.05.2010 20:55, Piotr Hosowicz wrote:
>>>
>>>>I could find the option in menuconfig and I don't want to edit .config
>>>>by hand, because there are various *SYSFS* options there.
>>>
>>>Sorry, I mistyped, I meant I _cannot_ find it in menuconfig nor in .config.
>>
>>The only thing about  SYSFS that is deprecated AFAIK is in init/Kconfig:
>>
>>config SYSFS_DEPRECATED_V2
>>	bool "enable deprecated sysfs features to support old userspace tools"
>>	depends on SYSFS
>>	default n
>>	select SYSFS_DEPRECATED
>>	help
>>	  This option switches the layout of sysfs to the deprecated
>>	  version. Do not use it on recent distributions.
>
>Thanks, I have it disabled. I asked tyhe question because of such
>messages during boot:
>
>May 13 16:26:24 aapi205 udevd[1432]: SYSFS{}= will be removed in a
>future udev version, please use ATTR{}= to match the event device, or
>ATTRS{}= to match a parent device, in
>/etc/udev/rules.d/025_logitechmouse.rules:21
>

It is a warning for udev rules, that is saying you should replace
SYSFS{}= with ATTR{}= in your rule file under /etc/udev/rules.d/,
nothing related with kernel.

Thanks.
