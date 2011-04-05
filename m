Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1DEG3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:29:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50150 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1DEG3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:29:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Date: Tue, 5 Apr 2011 08:29:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <alpine.DEB.2.00.1104041616550.16492@kaball-desktop> <20110404162516.GA31241@elte.hu>
In-Reply-To: <20110404162516.GA31241@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104050829.58474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 04, 2011, Ingo Molnar wrote:
> 
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > On Mon, 4 Apr 2011, Ingo Molnar wrote:
> > > 
> > > * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > > 
> > > > Just to clarify the situation the patch "x86-64: finish cleanup_highmaps()'s 
> > > > job wrt. _brk_end" was backported to the stable trees [...]
> > > 
> > > There's no commit with such a title upstream - there's not even one that is 
> > > close. Could you cite the sha1 you refer to?
> > 
> > The commit id upstream is 498343967613183611ac37dccb2846496d954c06
> 
> That commit is from the v2.6.30 era:
> 
>  |
>  | commit 498343967613183611ac37dccb2846496d954c06
>  | Author:     Jan Beulich <jbeulich@novell.com>
>  | AuthorDate: Wed May 6 13:06:47 2009 +0100
>  | Commit:     H. Peter Anvin <hpa@zytor.com>
>  | CommitDate: Thu May 7 21:51:34 2009 -0700
>  |
>  |    x86-64: finish cleanup_highmaps()'s job wrt. _brk_end
>  |
> 
> ... i.e. the bug is almost 2 years and 8 -stable cycles old!
> 
> Peter very consciously did not mark the fix for this commit as -stable 
> material. It was ineligible for -stable for multiple reasons: it by no means 
> fixed a 2.6.39 regression and the fix was literally just a few days old.

Has this issue been resolved in the mainline, BTW?

Rafael
