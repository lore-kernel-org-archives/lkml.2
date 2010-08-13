Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236Ab0HMAfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:35:31 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:59242 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752423Ab0HMAf2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:35:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=o2XM97zD2Vq7af2WSiZuPsWrvOW7rzspMnmoFjhZBdkz7m2qUuNq31aPWVhPIvZbW47FrMZoHXyB0Eq4arlYN+ULJIyEF3zEulpT+WDUcReFmPkKnSr0+eOvJy5L4e+A;
Date: Thu, 12 Aug 2010 17:35:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: Fix support for PCI domains
Message-ID: <20100812173526.2c002045@blake>
In-Reply-To: <AANLkTik+MX8cKz6hWyaa8Z2gK7fehXzjSPpeiyExuMjb@mail.gmail.com>
References: <1281066910.2168.10.camel@pasglop>
	<AANLkTinmhGPHQDX0gmnY9j+K61abgnukw2DrTBG3EUuJ@mail.gmail.com>
	<AANLkTi=BowHspOUSDmwkdN3o9qhh6rJtEZwCnTRP-VrS@mail.gmail.com>
	<20100812164557.5f2513a6@virtuousgeek.org>
	<AANLkTik+MX8cKz6hWyaa8Z2gK7fehXzjSPpeiyExuMjb@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hm, so pci_domain_nr should just return 0 on platforms where
> > CONFIG_PCI_DOMAINS isn't set.  I'd expect that to be the case when
> > CONFIG_PCI=n...  Maybe we just need to shuffle the definition
> > around?
> 
> I suspect something like the attached would suffice.
> 
> Or maybe moving the CONFIG_PCI_DOMAINS checkout outside CONFIG_PCI.

Yeah, that looks ok, and better than putting it in drm.  I'll apply to
my for-linus branch for the next PCI fixes pull.

Thanks,
Jesse
