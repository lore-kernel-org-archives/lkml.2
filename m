Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1ELT0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:26:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757519Ab1ELT0h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110512113726.123fd85b@jbarnes-desktop>
References: <20110506081243.GF16782@ram-laptop> <4DC4586C.6020308@kernel.org>
 <20110507015240.GN16782@ram-laptop> <4DC4B059.3030502@kernel.org>
 <4DC64C58.70203@kernel.org> <20110509142014.617e3100@jbarnes-desktop>
 <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com> <4DC9E415.5010402@kernel.org>
 <20110512180638.GA5012@ram-laptop> <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
 <20110512182229.GQ8195@ram-laptop> <20110512113726.123fd85b@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 12:18:43 -0700
Message-ID: <BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Linus, I don't have anything else queued up, so you may as well take
> this one directly if you want it in 2.6.39.  It's a regression fix, but
> resource changes always make me nervous.  Alternately, I could put it
> into 2.6.40 instead, the backport to 2.6.39.x if it survives until
> 2.6.40-rc2 or so...

Considering the trouble resource allocation always ends up being, I'd
almost prefer that "mark it for stable and put it in the 2.6.40
queue".

Afaik this problem hasn't actually hit any "normal" users, has it? So ...

                        Linus
