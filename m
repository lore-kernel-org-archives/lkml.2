Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0EKS7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:59:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab0EKS7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=AiYItw2gm8cpZatUDn7MGZDKS02nshxJAWNLuyMT489CMITVf3E4GwDV/V4nqL1ClP
         kxWra20S8czUEkRyuZvsAEPtbMg8Vc49lQ+17+IR5B9qyexoghp4gK/OS2xgOhXcqOi2
         BKHPa1M9pPNi7FCD/+DDvsE7AMzk7GSBNuc1I=
Date: Tue, 11 May 2010 20:59:18 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipheth device not showing up
Message-ID: <20100511205918.70c21413@varda>
In-Reply-To: <20100511165159.GA9614@gamma.logic.tuwien.ac.at>
References: <20100511165159.GA9614@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 12 May 2010 01:51:59 +0900
Norbert Preining <preining@logic.at> escribió:

> Hi everyone, 
[ ... ]
> 
> It actually looks good:
> [46128.590402] usb 2-1: Product: iPhone
> [46128.590407] usb 2-1: Manufacturer: Apple Inc.
> [46128.590411] usb 2-1: SerialNumber: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
> [46128.717504] ipheth 2-1:4.2: Apple iPhone USB Ethernet device attached
> 
> so it seems that there should be an ethernet device, but ifconfig -a
> or any other way I can imagine to check does not show the new device.
> 
> Am I missing something?

 http://giagio.com/wiki/moin.cgi/iPhoneEthernetDriver

  The "pairing" program in the link above ? Google is your friend :)

> 

