Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab0HFAna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:43:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36035 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab0HFAn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:43:28 -0400
Date: Fri, 06 Aug 2010 09:43:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the input tree with the s5p tree
In-reply-to: <20100806102419.3e875933.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Message-id: <004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acs0/cleAGnVUNgoTViB/9LOZnUgTQAAXshA
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
 <20100806102419.3e875933.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi all,
> 
> On Thu, 22 Jul 2010 11:46:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
> >
> > Today's linux-next merge of the input tree got a conflict in
> > arch/arm/plat-samsung/include/plat/keypad.h between commit
> > 1e3241300503df18a098dd35098f6975dcf622e2 ("ARM: SAMSUNG: Add keypad
> > device support") from the s5p tree and commit
> > 0fffed27f92d9d7a34de9fe017b7082b5958bb93 ("Input: samsung-keypad - Add
> > samsung keypad driver") from the input tree.
> >
> > This just looks like two versions of the same driver (or two drivers
> > sharing the same header) - please sort this out.  I have fixed up the
> > header for today (by including both versions where necessary).
> 
> I got this again (something obviously changed a little) but the input
> tree version is now in Linus' tree.  Please fix this up.

Hi Stephen,

Yeah,

I know that Dmitry's 'Input: samsung-keypad...patch' which includes
plat/keypad.h has been merged Linus' tree in this merge window.
And Joonyoung's another patch which is in my tree needs to update it, but my
tree is don't having it against Linus' 2.6.35.

So happened conflict...how can/should I handle this...
Should I rebase my tree against Linus' latest?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

