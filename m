Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0FHTIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:08:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35553 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab0FHTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:08:52 -0400
Date: Tue, 8 Jun 2010 21:08:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
Message-ID: <20100608190848.GD25985@elte.hu>
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
 <4C0E949D.6090002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0E949D.6090002@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/08/2010 11:28 AM, Yuhong Bao wrote:
> > 
> > Adding mingo and gregkh to CC list.
> >> Remember the lowmem corruption problems that lead the code that displays this to be added to Linux:> AMI BIOS detected: BIOS may corrupt low RAM, working around it.> which was IMO way too broad. Good news, the Windows side agree that this is a problem too:> http://www.microsoft.com/whdc/system/platform/firmware/mem-corrupt.mspx>> Yuhong Bao
> > 
> 
> Hardly "way too broad".  I'm starting to think we should enable it
> unconditionally, given the number of machines which have exhibited that
> problem.  As shown in the whitepaper, Vista/Win7 even avoid using
> < 1 MB for a lot of things, presumably for this reason.
> 
> If it only was suspend, it would be one thing, but from what I've seen
> it has been known to happen at other times too (e.g. HDMI cable insertion!)

Yep, patterns of some silly OSD bitmap showed up in one of the corruption - 
firmware displaying a 'you inserted a cable' kind of icon somewhere and 
messing up the SMM code or so ...

I agree that dis-using <1M by default is probably the sanest option.

	Ingo
