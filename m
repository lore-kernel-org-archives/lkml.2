Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2HJDtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:49:15 -0400
Received: from zougloub.eu ([188.165.233.99]:51254 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760333Ab2HJDsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:48:41 -0400
Date: Thu, 9 Aug 2012 23:49:37 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: "Matt Fleming" <matt.fleming@linux.intel.com>
Cc: "Jan Beulich" <JBeulich@suse.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120809234937.53f72c32@zougloub.eu>
In-Reply-To: <5020DC5F02000078000931C2@nat28.tlf.novell.com>
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com>
 <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
 <20120806223208.5301be0d@zougloub.eu>
 <20120806230629.153d33bd@zougloub.eu>
 <5020DC5F02000078000931C2@nat28.tlf.novell.com>
Organization: none
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI I tried to contact support, here's their answer:

Dear Valued Customer,

Thank you for contacting ASUS Customer Service.

My name is Carter and it's my pleasure to help you with your problem.

I am afraid to say this board doesn't support linux,so we can't asure the compability.
It is depengding on the actual situation.

If you continue to experience issues in the future, please do not hesitate
to contact us.

Best Regard 
Carter


---------- Original Message ----------
>From : cj-as@zougloub.eu
Sent : 2012/8/7 ?? 01:18:04
To : "tsd@asus.com.tw"
Subject : <TSD> Motherboard SABERTOOTH 990FX 

[CASEID=WTM201208072118475482]

Apply date : 8/7/2012 1:18:47 PM(UTC Time)

[Contact Information]
*Name : Jérôme Carretero
*Email Address : cJ-as@zougloub.eu

[Product Information]
*Product Type : Motherboard
*Product Model : SABERTOOTH 990FX
*Product S/N : MB-1234567890

[Motherboard Specification]
*Motherboard Revision : 1.xx
*Motherboard BIOS Revision : 813

*Operating System : Linux 

[Problem Description]
Hi,

A proposed patch to Linux uses EFI GetTime service to get the wall clock time.
It seems this function does not work properly.
See http://www.gossamer-threads.com/lists/linux/kernel/1576468
I know I don't have the latest bios but the change logs don't mention any EFI change,
and upgrades make the settings lost, so I didn't try them.

Thanks,

-- 
cJ

