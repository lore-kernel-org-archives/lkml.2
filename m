Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab2HXOks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:40:48 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:59372 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab2HXOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:40:44 -0400
Message-ID: <503792CC.6050209@laposte.net>
Date: Fri, 24 Aug 2012 16:42:20 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1368810.q4rGz16CTW@linux-lqwf.site> <50374B69.3040002@laposte.net> <1555763.Oi7gGGn7BU@linux-lqwf.site>
In-Reply-To: <1555763.Oi7gGGn7BU@linux-lqwf.site>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 24/08/2012 13:41, Oliver Neukum a écrit :
> On Friday 24 August 2012 11:37:45 Yann Cantin wrote:
>> Hi,
>>
>> Le 23/08/2012 09:23, Oliver Neukum a écrit :
>>> On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:
> 
>>> These functions are identical. You should unify them.
>>
>> Removed reset_resume from the driver (optional, and not needed
>> for this hardware).
> 
> Why did you do that? It is always better to have reset_resume().
> And you cannot tell whether it will be needed.

This function was used in usbtouchscreen (which this driver is based on)
for some hardware specific init after reset. eBeam devices doesn't need that,
and i didn't mention the similarity of the 2 functions after stripping the code.

According to power-management.txt, reset_resume is optional, and lot of input
driver lack it. Anyway, if you think it's worth the code, i'll re-add a 
reset_resume function proxing resume like wacom_sys.c do.

-- 
Yann Cantin
A4FEB47F
--
