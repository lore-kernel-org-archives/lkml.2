Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1DRR1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:27:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33291 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1DRR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ED9IzM2Vusaq53M/0bBBrgkWWpMJOh1zp1tlK4pcnq2iEOhq4NVNijvGQRHbOBVMuf
         3QpyNyx73AQdutLnqo0MG7CHhs1eZim4+NojKPX0g1HIMRJXEz3y82MoaV9MbnYC0C8I
         bj+pGi4LWstjTEhRQhQHmslRFxCX5S1NAxBCY=
Message-ID: <4DAC7487.6050204@gmail.com>
Date: Tue, 19 Apr 2011 01:27:35 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
References: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com> <BANLkTikDtpg2CKM_Rq9hZ44F4jHvM3bOdg@mail.gmail.com> <201104180926.17457.oneukum@suse.de>
In-Reply-To: <201104180926.17457.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-4-18 15:26, Oliver Neukum wroted:
> Am Montag, 18. April 2011, 02:54:16 schrieb Wanlong Gao:
>>> -
>>> /***************************************************************************
>>>        The USB Part of the driver
>>> ****************************************************************************/
>>> --
>>> 1.7.3.2.343.g7d43d
>>>
>> Why did you change it ? and why change so many lines ?
>> It had some thing wrong ?
>
> Exactly. This is a driver for legacy hardware. Could you leave it alone
> unless you fix a real, as in makes a difference to code generation, bug?
>
> 	Regards
> 		Oliver
Hmm..Maybe he just want to make to code nice . and didn't think as more 
about this as you .

Thanks
Regards

	Wanlong Gao
