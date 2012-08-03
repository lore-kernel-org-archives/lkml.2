Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2HCMNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:13:01 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:45362 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2HCMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:12:57 -0400
Message-ID: <501BC063.9040502@laposte.net>
Date: Fri, 03 Aug 2012 14:13:23 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v2 0/3] new USB eBeam input driver
References: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net> <alpine.LRH.2.00.1208021602250.15211@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1208021602250.15211@twin.jikos.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 02/08/2012 16:16, Jiri Kosina a écrit :
>> Patch 1 and 2 are here to let the ebeam driver be choose to handle
>> the device instead of the generic-usb hid one (totally useless).
> 
> Just merge 1 and 2 together, not necessary to have two commits because of 
> that.

Ok, will do that for the next iteration of the patchset (i don't think
i need to resubmit now with this change only, no?)

Thanks.
-- 
Yann Cantin
A4FEB47F
--
