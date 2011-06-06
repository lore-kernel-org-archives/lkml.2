Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1FFRlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:41:49 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:49154 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab1FFRlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:41:47 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Jun 2011 18:41:44 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <airlied@linux.ie>
Subject: Re: [PATCH] tentative fix for radeon on systems >4GB without
 hardware iommu
In-Reply-To: <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
References: <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
 <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
 <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
 <20110601222226.GH27166@one.firstfloor.org>
 <72a54a970741bfc342467045351df812@admin.gogi.tv>
 <BANLkTik+p65G5f08RfxiYojvAax_nrDiqg@mail.gmail.com>
Message-ID: <f2b1d34b5be1bb910f82b961956c3787@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like the correct fix. rdev->need_dma32 is used when we 
> init
> ttm for memory management later.

 Is there anything I have to do now to have it included? Will it also
 go into the stable releases?
