Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2CPTab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:30:31 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:43795 "EHLO
	homiemail-a49.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932133Ab2CPTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:subject:content-type:
	content-transfer-encoding; q=dns; s=shealevy.com; b=EA56QGTTZoqi
	tfswKrnbfb1BKhW+yRZHz8wbKs2I0jX9AHsfKJf3/2C9VevBiA6sWvjoTS9JH0A3
	Q3g09VZyVDq0hLjaW2Xb3+JIaGZeHQEJ2hKu26VA3JcB9jGN+I6SLgulSM7Nglq4
	xFDwVPnrY6+7FNsJ1sE6g3/2rebuUAc=
Message-ID: <4F6394D0.3090104@shealevy.com>
Date: Fri, 16 Mar 2012 15:30:24 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: EFI Boot Stub on Removable Media
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently working on making the live CDs for the NixOS distribution 
EFI-bootable with the EFI boot stub as the bootloader. Is there a 
recommended way to use a boot-stub enabled kernel on a removable device 
(where, AFAIK, there is no way to tell the firmware what params to boot 
with automatically)? Currently, I'm hacking together a really 
quick-and-dirty UEFI application that reads a parameters file at a 
pre-defined location and loads the kernel with those parameters, but I'd 
love a better alternative. Is it possible to embed an initrd in a 
bzImage after the image is built? Or is there some way to have a CD tell 
the firmware what arguments to pass to \EFI\BOOT\BOOT{ARCH}.EFI? Or some 
easy tweak to the kernel source to have it use a set of default 
parameters in absence of explicitly passed ones?

Cheers,
Shea Levy
