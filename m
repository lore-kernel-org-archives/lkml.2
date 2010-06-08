Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0FHTWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:22:47 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40357 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755145Ab0FHTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:22:46 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Windows side agrees that lowmem corruption is a problem too
Date: Tue, 8 Jun 2010 21:22:20 +0200
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yuhong Bao <yuhongbao_386@hotmail.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl> <4C0E949D.6090002@zytor.com> <20100608190848.GD25985@elte.hu>
In-Reply-To: <20100608190848.GD25985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006082122.25089.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 June 2010 21:08:48 Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> > On 06/08/2010 11:28 AM, Yuhong Bao wrote:
> > > Adding mingo and gregkh to CC list.
> > >
> > >> Remember the lowmem corruption problems that lead the code that
> > >> displays this to be added to Linux:> AMI BIOS detected: BIOS may
> > >> corrupt low RAM, working around it.> which was IMO way too broad. Good
> > >> news, the Windows side agree that this is a problem too:>
> > >> http://www.microsoft.com/whdc/system/platform/firmware/mem-corrupt.msp
> > >>x>> Yuhong Bao
> >
> > Hardly "way too broad".  I'm starting to think we should enable it
> > unconditionally, given the number of machines which have exhibited that
> > problem.  As shown in the whitepaper, Vista/Win7 even avoid using
> > < 1 MB for a lot of things, presumably for this reason.
> >
> > If it only was suspend, it would be one thing, but from what I've seen
> > it has been known to happen at other times too (e.g. HDMI cable
> > insertion!)
>
> Yep, patterns of some silly OSD bitmap showed up in one of the corruption -
> firmware displaying a 'you inserted a cable' kind of icon somewhere and
> messing up the SMM code or so ...
>
> I agree that dis-using <1M by default is probably the sanest option.

But please limit it to newer systems only (DMI present && year > 200?). There 
are many old machines running fine. Losing 1MB from 16MB is a bad thing.

-- 
Ondrej Zary
