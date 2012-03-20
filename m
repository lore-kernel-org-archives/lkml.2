Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2CTWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:09:15 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:33405 "EHLO
	homiemail-a91.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758609Ab2CTWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:subject:content-type:
	content-transfer-encoding; q=dns; s=shealevy.com; b=YU/tcrsv/pvD
	sGD6s+KlqcsqMff2t/l8ihOfLW70sDVUNuTGl/nMtwYuV+U7LbZTmM7rod3viAQ+
	QmvHFJUFN5sHUyRQZNF8qGE9DxKng76JrC7Gnahk9EZm7GWKjQhh7SLp2CiPGtnD
	M2FVbRv1hY8jkVMkfR3iRzA4Fgsf0N0=
Message-ID: <4F690003.1040404@shealevy.com>
Date: Tue, 20 Mar 2012 18:09:07 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120311 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: Macbook Pro 5,3 Video Issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my system (Linux 3.3, booting in EFI mode, using Nouveau with 
nouveau.noaccel=1 due to 
https://bugs.freedesktop.org/show_bug.cgi?id=27501 ), I can't figure out 
how to change the backlight or switch which of the two graphics cards (I 
have an Nvidia 9600M GT and a 9400M, both are recognized by nouveau but 
only the 9400M is ever used) Linux uses for the framebuffer or X uses 
for the output. I have /sys/class/backlight/nv_backlight, and writting 
to nv_backlight/brightness does change the value in 
nv_backlight/actual_brightness, but no actual screen changes occur. I'm 
using the in-tree staging version of nouveau, so I wasn't sure which ML 
this should go to.

Cheers,
Shea Levy
