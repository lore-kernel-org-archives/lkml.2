Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2LMHHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:07:48 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:43092 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2LMHHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:07:47 -0500
Message-ID: <50C97EBE.20402@laposte.net>
Date: Thu, 13 Dec 2012 08:07:42 +0100
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Thunderbird/10.0.11
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: ebeam PATCH (new eBeam input driver)
References: <1349529287-23193-1-git-send-email-yann.cantin@laposte.net>
In-Reply-To: <1349529287-23193-1-git-send-email-yann.cantin@laposte.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Do i need to resubmit the patchset for the next merge window ?

If so, do you guys prefer it against linus or next branch ?

For the record :

> New USB input driver for eBeam devices.
> 
> Currently supported (tested) :
> - Luidia eBeam classic projection and edge projection models
> - Nec "interactive solution" NP01Wi1 & NP01Wi2 accessories.
> 
> Patch 1 to blacklist the devices for hid generic-usb.
> 
> Patch 2 is the actual driver.

-- 
Yann Cantin
A4FEB47F
--
