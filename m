Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0LaWFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 17:05:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38679 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0LaWFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 17:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=jJSbxeXfk5y4UcT3SV2grO+mIveRgt4+3do/f01pbkdy4ZQ3fmBLutyYi1tExe6NKH
         E3LePg6h39jksylyJR7LSUoCX3YuSJPKla0Dgdj0rLwuVsww/FLPq4djBEkqk+Q7dLVD
         P8lWVjfvJtH1Mbe0WazsOEn9ubZ1kKwK0Rpto=
Date: Sat, 1 Jan 2011 00:05:58 +0200
From: Yotam Medini <yotam.medini@gmail.com>
To: Avery Pennarun <apenwarr@alumnit.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-ID: <20110101000558.56c77a55@janini.home>
In-Reply-To: <AANLkTi=GY+ZFNMCdCQAj7aL6smUmiJZ=a-kcc76EECj7@mail.gmail.com>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
	<20101231212800.1e47f200@janini.home>
	<20101231113954.dc9adbdf.rdunlap@xenotime.net>
	<20101231234010.0165f0e8@janini.home>
	<AANLkTi=GY+ZFNMCdCQAj7aL6smUmiJZ=a-kcc76EECj7@mail.gmail.com>
Reply-To: yotam.medini@gmail.com
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 13:54:59 -0800
Avery Pennarun <apenwarr@alumnit.ca> wrote:

> > I do get:
> >
> >  $ sudo modprobe apm
> >  FATAL: Error inserting apm
> >    (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device  
> 
> The output of 'dmesg' might be revealing here.  However, it's likely
> that your PC doesn't actually support APM unless it's *very* old.  You
> might want to try ACPI instead.
> 
> Hope this helps.
> 
> Avery

Indeed:
    $ dmesg  | grep -i apm
    [   52.897795] apm: BIOS not found.
I will try to investigate this.

But I clearly remember that a few years ago, I could issue:
    $ cat /proc/apm
and see the battery status.
Then, I believe, the kernel tree used to have arch/i386.

thanks -- yotam
