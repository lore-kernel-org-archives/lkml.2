Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0FFKm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:42:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63521 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0FFKm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Xte9Wev9fsHsKSZTB+avdwsst8TQgMjdBNNhhrk3mVNs8BA9HhkrkW9bJ6/uBxHeTw
         XabkBDizm5PCak8pGmWTvu/bFHpRdbg94qg0EgspVsKk0v45K45z53k4oF/SzCH8VxCS
         jkX9jXYTc/1MSDn50KB4DYuH638BH3GOwgGdo=
Date: Sun, 6 Jun 2010 12:42:21 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: DanVolkman <danvolkman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.32-22-generic sata problems
Message-ID: <20100606124221.0bbbe8c6@varda>
In-Reply-To: <4C0B5307.1020206@gmail.com>
References: <4C0A6326.1090100@gmail.com>
	<4C0B5307.1020206@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 06 Jun 2010 01:49:27 -0600
Robert Hancock <hancockrwd@gmail.com> escribió:


> 
> Can you get any of the libata messages showing up on the console? You 
> might need to change grub options to boot with more debug displayed 
> (don't know how to do that offhand on Ubuntu).

 Edit /etc/default/grub change
 GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
 to
 GRUB_CMDLINE_LINUX_DEFAULT=""
 Then run « sudo update-grub »
 
 To see normal boot messages. 
 
