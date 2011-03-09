Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1CIXQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:16:04 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41045 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1CIXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=oYCalHKYqaCZSNV7emKM+cTLAaqwWb/ihS2S+HIYWaqp/4Phu2Y2qEAMuOdVy2RMnC
         JuELCPwMLv5Gcx94d7z9I1gX+0yPQnfeQ5mDdZEuX72EpVntVhMNVn7MdNXNfAYzM/8l
         HxzvxPuYQLLVkGkxWJu9Wd/AxV9HUxoW/9t4U=
From: Wang Lei <f3d27b@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<201103091141.28396.rjw@sisk.pl>
	<4d77806c.0bf98e0a.28c5.7cc5@mx.google.com>
	<201103092125.43950.rjw@sisk.pl>
Date: Thu, 10 Mar 2011 07:16:14 +0800
In-Reply-To: <201103092125.43950.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 9 Mar 2011 21:25:43 +0100")
Message-ID: <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday, March 09, 2011, Wang Lei wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> >
>> > There was only one commit in that area since 2.6.38-rc6, but it shouldn't
>> > affect the functionality this way.
>> >
>> > Is yout thermal management controlled by ACPI?
>> >
>> > Rafael
>> 
>> Thanks for your reply!
>> 
>> How could I know that?
>
> What does "ls -l /sys/class/thermal/cooling_device0/device" say?
>
> Rafael

[~]$ ls -l /sys/class/thermal/cooling_device0/device
lrwxrwxrwx 1 root root 0 Mar 10 07:13 /sys/class/thermal/cooling_device0/device -> ../../../LNXSYSTM:00/device:47/PNP0C0B:00
[~]$

-- 
Regards,
Lei
