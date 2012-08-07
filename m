Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2HGA4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 20:56:05 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:57037 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2HGA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 20:56:03 -0400
Message-ID: <502067C8.2020204@laposte.net>
Date: Tue, 07 Aug 2012 02:56:40 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 2/2] input: misc: New USB eBeam input driver.
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net> <1344288104-20731-3-git-send-email-yann.cantin@laposte.net> <20120806214359.GB30355@kroah.com>
In-Reply-To: <20120806214359.GB30355@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 06/08/2012 23:43, Greg KH a écrit :
> On Mon, Aug 06, 2012 at 11:21:44PM +0200, Yann Cantin wrote:
>>
>> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
>> ---
>>  drivers/input/misc/ebeam.c |  764 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 764 insertions(+)
>>  create mode 100644 drivers/input/misc/ebeam.c
> 
> What adds this file to the build?
 
Sorry, i don't get it : what do you mean ?

> greg k-h

-- 
Yann Cantin
A4FEB47F
--
