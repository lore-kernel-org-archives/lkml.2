Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1FFRpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:45:53 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:33490 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab1FFRpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:45:52 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Jun 2011 18:45:51 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tentative fix for radeon on systems >4GB without
 hardware iommu
In-Reply-To: <20110603231350.GA20316@dumpdata.com>
References: <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
 <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
 <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
 <20110601222226.GH27166@one.firstfloor.org>
 <72a54a970741bfc342467045351df812@admin.gogi.tv>
 <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
 <20110603231350.GA20316@dumpdata.com>
Message-ID: <cb4f6d1849a56b2b73dc83b253346ed7@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Daniel, did you find other graphic drivers that forget to set 
> need_dma32
> after failing to set the dma_mask ?

 No. I have looked at nouveau and they seem to do it correctly, but I 
 can
 not test it because I do not have the hardware.
