Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1A3ATt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:19:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1A3ATr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:19:47 -0500
Message-ID: <4D44AE75.6020803@zytor.com>
Date: Sat, 29 Jan 2011 16:19:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
References: <4D41EA12.1030402@free.fr> <201101272354.00042.rjw@sisk.pl> <4D447C00.70709@free.fr> <201101292215.57292.rjw@sisk.pl>
In-Reply-To: <201101292215.57292.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2011 01:15 PM, Rafael J. Wysocki wrote:
>
> That's correct, but those changes can wait.  The most urgent thing is to fix
> the resume regression at hand.  I guess we should ask the reporter's in
> https://bugzilla.kernel.org/show_bug.cgi?id=27472 to test that patch, right?
>

By the way, guys: I'm on vacation at the moment, but I do monitor this 
thread.  I think at this point we should revert NX for the low 1 MiB and 
worry about doing it properly for .39.  That being said, this kind of 
unification is a good thing in general.

	-hpa
