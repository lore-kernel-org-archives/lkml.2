Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0EIWvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:51:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47102 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0EIWvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oAI+QlY42T2r6TVoldQhit1KfsllSWLVsn1YU6He7zrAXAPJ501a/k78U1FsWJGO+l
         /F8E5N6MOQpyMeS1E5APmhcZnJHbmOx9y2odtNoPKI2mbkErxlCbwI7RdoywSTdcVD54
         fpEir268jOXT9NYCPIgKNzzsHmlLfJG+Asomg=
MIME-Version: 1.0
In-Reply-To: <k2le9c3a7c21005091026y9140dd46i8020c49ebef7c06c@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
	 <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
	 <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
	 <l2j1b68c6791005082048j5deaf863g2887c968ff841f2f@mail.gmail.com>
	 <h2ie9c3a7c21005090047lf1157930t9a625073c87e8cea@mail.gmail.com>
	 <l2r1b68c6791005090306ld948bebfqa1e7d22321e302aa@mail.gmail.com>
	 <k2le9c3a7c21005091026y9140dd46i8020c49ebef7c06c@mail.gmail.com>
Date: Mon, 10 May 2010 07:51:07 +0900
Message-ID: <x2q1b68c6791005091551r6e5abe65l9887e2537a86cf2e@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: jassi brar <jassisinghbrar@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 2:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, May 9, 2010 at 3:06 AM, jassi brar <jassisinghbrar@gmail.com> wrote:
>> This discussion is purely about what the current DMA API misses and what
>> a generic DMA API should do. So, that the current DMA API fills up those
>> gap, if possible. I would love to get started implementing the generic
>> DMA API for reference but my priorities are decided by my employer.
>
> Well, the only significant miss that has been identified so far is
> dynamic channel allocation for the device-to-mem case.  Everything
> else can be done with small tweaks to the existing interface.  But
> some of this discussion reminds me of Section 2.4 of
> Documentaion/SubmittingPatches:
>
> 4) Don't over-design.
>
> Don't try to anticipate nebulous future cases which may or may not
> be useful:  "Make it as simple as you can, and no simpler."
There is a fine line between anticipating future requirements and
over-designing.

We already have Samsung's and STM's SoC sharing a DMAC IP.

Esp with PrimeCells, we are soon likely to see SoCs sharing a
peripheral IP with possibly different DMACs.

Some elements may be ideal-design at the cost of over-design, but not all.
Let us not simply brush aside all concerns as over-designing.
