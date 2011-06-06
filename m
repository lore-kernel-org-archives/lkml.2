Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab1FFTI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:08:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32865 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1FFTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dUeuNRPuLihazTGP8QevPdzYMl/C/gr3En04ga3plrPC0OsPHh+TOSYMCZSfxM9zYz
         EYk/Qs1i1p+73GofhkANtHiuCBRNiCY5/p1saNT+CTk82VssPuq/ixZlcFB8t4BOB6Cn
         sb9hgyFGGoQ6k4Tr8BxQH607xxT17y7/r8fr4=
MIME-Version: 1.0
In-Reply-To: <f2b1d34b5be1bb910f82b961956c3787@admin.gogi.tv>
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
	<f2b1d34b5be1bb910f82b961956c3787@admin.gogi.tv>
Date: Mon, 6 Jun 2011 15:08:56 -0400
Message-ID: <BANLkTimJfcEcS4mKXgRHnzMDKn2awtp5QQ@mail.gmail.com>
Subject: Re: [PATCH] tentative fix for radeon on systems >4GB without hardware iommu
From: Alex Deucher <alexdeucher@gmail.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 1:41 PM, Daniel Haid <d.haid@gogi.tv> wrote:
>> This looks like the correct fix. rdev->need_dma32 is used when we init
>> ttm for memory management later.
>
> Is there anything I have to do now to have it included? Will it also
> go into the stable releases?
>

I think Dave will pick it up and send it through the drm tree.

Alex
