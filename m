Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1C0ONB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 10:13:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1C0ONA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 10:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=rNEQX5/Ki4pLdN2OW6y6H+iKV04YXTMio9EAGERqbdmvTByNOUnpMwK2h4eszaPvEm
         d64l7c8N48iH4dN4F1CNWm8gqrdSsH9Elo6WorZCWqBcGbRrNtgqiYySSt2qQLuJ0l1R
         KQ5weEtea+b7UgXOAMK2DTjJYTK1SKLPv1clA=
Date: Sun, 27 Mar 2011 22:12:53 +0800
From: "wanlong.gao" <wanlong.gao@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: "greg" <greg@kroah.com>, "harryxiyou" <harryxiyou@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>,
 <20110327125359.GA5816@p183.telecom.by>
Subject: Re: Re: [PATCH] Fixed the format: lines over 80 characters .
Message-ID: <201103272212485463946@gmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2REDSs3004266

I see, thanks .

------------------				 
wanlong.gao
2011-03-27

-------------------------------------------------------------
·¢¼şÈË£ºAlexey Dobriyan
·¢ËÍÈÕÆÚ£º2011-03-27 21:54:05
ÊÕ¼şÈË£ºwanlong.gao
³­ËÍ£ºgreg; harryxiyou; linux-kernel
Ö÷Ìâ£ºRe: [PATCH] Fixed the format: lines over 80 characters .

On Sun, Mar 27, 2011 at 11:07:24AM +0800, wanlong.gao@gmail.com wrote:
>     Lines over 80 characters

>  static DEFINE_PCI_DEVICE_TABLE(cmodio_pci_ids) = {
> -	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_JANZ, 0x0101 },
> -	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_JANZ, 0x0100 },
> +	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
> +			PCI_VENDOR_ID_JANZ, 0x0101 },
> +	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
> +			PCI_VENDOR_ID_JANZ, 0x0100 },

NAK, this is less readable.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
