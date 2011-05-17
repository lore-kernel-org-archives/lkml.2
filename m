Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1EQFX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:23:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab1EQFXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110516205233.40ff7da4@jbarnes-e6510>
References: <4DC9E415.5010402@kernel.org> <20110512180638.GA5012@ram-laptop>
 <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com> <20110512182229.GQ8195@ram-laptop>
 <20110512113726.123fd85b@jbarnes-desktop> <BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com>
 <20110512123412.64e9b4cc@jbarnes-desktop> <4DCDD589.8010309@kernel.org>
 <20110516075926.GW8195@ram-laptop> <4DD18F4A.5030208@kernel.org>
 <20110516223621.GX8195@ram-laptop> <20110516205233.40ff7da4@jbarnes-e6510>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 May 2011 22:22:31 -0700
Message-ID: <BANLkTi=Ys3rnd3zhxK7A-ac+UKfjww+D6A@mail.gmail.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 8:52 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> I'll queue it up for 2.6.40 with stable cc'd.

I ended up taking it after all..

                   Linus
