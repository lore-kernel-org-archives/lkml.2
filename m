Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0GXXWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 19:22:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37412 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab0GXXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 19:22:51 -0400
X-Sasl-enc: zlALlkp7fIOf4sayk/n2yyv5HK2DvnEJTmzUFUDkZq6t 1280013770
Date: Sat, 24 Jul 2010 20:22:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, tj@kernel.org, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: support for drives larger than 2TiB
Message-ID: <20100724232247.GA2129@khazad-dum.debian.net>
References: <4C4AB952.9030705@kernel.org>
 <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>
 <AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jul 2010, Greg Freemyer wrote:
> Secondly, if you look at the table on the right of
> http://en.wikipedia.org/wiki/Master_boot_record#Disk_partitioning you
> see that the starting sector of a partition is defined with a 32-bit
> value.
> 
> ie. 2TB with 512 byte sectors.
> 
> The normal solution is to move to a GPT which requires EFI if you want
> to boot from it.

Can't one have a GPT with a guard boot sector which can read the real
partition table?

I think Tejun must mean some big problem at the BIOS APIs required for the
bootloader.  Tejun, what exactly croaks at the 2TB boundary (with 512KiB
sectors)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
