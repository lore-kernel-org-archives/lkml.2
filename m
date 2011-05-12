Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab1ELTe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:34:26 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:58388 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757008Ab1ELTeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:34:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mc37+GMhs9foecrt6u1/Xqx+1l1E8cqWPeYtrHHGhUQrQFfCeru+2Dzb12pUFms+V/zXcpKyR8mBKH6JVBlrxdCa2bdsqnzcqC2lj50NjVVie8ZypidWLEuyzUueqyVP;
Date: Thu, 12 May 2011 12:34:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource
 allocation.
Message-ID: <20110512123412.64e9b4cc@jbarnes-desktop>
In-Reply-To: <BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com>
References: <20110506081243.GF16782@ram-laptop>
	<4DC4586C.6020308@kernel.org>
	<20110507015240.GN16782@ram-laptop>
	<4DC4B059.3030502@kernel.org>
	<4DC64C58.70203@kernel.org>
	<20110509142014.617e3100@jbarnes-desktop>
	<BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>
	<4DC9E415.5010402@kernel.org>
	<20110512180638.GA5012@ram-laptop>
	<BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
	<20110512182229.GQ8195@ram-laptop>
	<20110512113726.123fd85b@jbarnes-desktop>
	<BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 12:18:43 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 12, 2011 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Linus, I don't have anything else queued up, so you may as well take
> > this one directly if you want it in 2.6.39.  It's a regression fix, but
> > resource changes always make me nervous.  Alternately, I could put it
> > into 2.6.40 instead, the backport to 2.6.39.x if it survives until
> > 2.6.40-rc2 or so...
> 
> Considering the trouble resource allocation always ends up being, I'd
> almost prefer that "mark it for stable and put it in the 2.6.40
> queue".
> 
> Afaik this problem hasn't actually hit any "normal" users, has it? So ...

Sounds good, thanks.  Yeah I don't think it's hit anyone but Yinghai
(at least I don't know of any other reports).

-- 
Jesse Barnes, Intel Open Source Technology Center
