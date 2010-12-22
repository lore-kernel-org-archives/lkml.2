Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0LVUUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:20:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0LVUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uo4idTj+u9xtFfk1kbIodP6b/mqhbUGn8v9aF1T2VTUEci18g4tAyl2PB1CVi4B8om
         bxEfIvQL84sAaZ7olo2Eq5dIU1BQcLSWO52EgIdXRHJIZ281UvEMkzHcKmyEx3U4lE4d
         xpJ8EzDpidu0c5b5XO6GzVruKgmqFBIH1CFqg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012211437120.12146@localhost6.localdomain6>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	<alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	<alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
	<alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
	<alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
	<alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
	<alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
	<alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
	<alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
	<alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
	<alpine.LFD.2.00.1007311530510.2471@localhost.localdomain>
	<alpine.LFD.2.00.1008031118270.3225@localhost.localdomain>
	<alpine.LFD.2.00.1012211437120.12146@localhost6.localdomain6>
Date: Wed, 22 Dec 2010 21:20:11 +0100
X-Google-Sender-Auth: Fp8euMdyahsV5SzTtkZrYW2eOWM
Message-ID: <AANLkTin_pDS63RQT5SWd994P-SpmmHr1MTP_UGyApg4P@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33.7-rt29
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2010/12/21 Thomas Gleixner <tglx@linutronix.de>:
>
> At this point I want to say thanks to everyone who supported the
> development of the -rt patches with testing, bugfixes, stable
> backports etc. in the last years.

First of all: Thank YOU for maintaining the RT-patch and the huge
amount of effort you put into it!

> I hope that I can rely on your help
> for the upcoming 37 release and the ongoing effort to merge the patch
> fully into the mainline.

>From my side: I will test this new patch next Friday on ARM/at91, and
when 2.6.37-rt becomes available: I am happy to test that one also.

> I wish you all a Merry Christmas and a Happy New Year!

Merry Christmas and a Happy New Year to you and anyone else too!

Kind regards,

Remy
