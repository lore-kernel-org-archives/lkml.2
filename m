Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2HWVnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:43:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304Ab2HWVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <87sjbfy0ue.wl%kuninori.morimoto.gx@renesas.com>
References: <20120706161455.dd899154fbc8a79ee530572f@canb.auug.org.au>
	<CACRpkdbZddOBf0PXFJjr_aRD3TEa9hSvXjAjf3--8Ko_W0zZcg@mail.gmail.com>
	<w3psjd55kwl.wl%kuninori.morimoto.gx@renesas.com>
	<CACRpkdb=bg7fc1HEW5U2PBjs_hLDRgGUNP=O6BEJRmYfCiSWpA@mail.gmail.com>
	<87r4slg063.wl%kuninori.morimoto.gx@renesas.com>
	<CACRpkdYSLRiAQd3kGGv8xktAvi+YbBSe1hGqMX2y7fFXQOHPXQ@mail.gmail.com>
	<87sjbfy0ue.wl%kuninori.morimoto.gx@renesas.com>
Date: Thu, 23 Aug 2012 23:43:10 +0200
Message-ID: <CACRpkdaOyA2jPLkimQEtPFVYyRpxQGV7nV+6kiZ5_+mV827ytw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 7:03 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:

> Now, these fixup patches were accepted.
>   http://git.kernel.org/tip/17d83127d4c2b322dd8f217e0ac08c66eb403779
>   http://git.kernel.org/tip/b3ae66f209e8929db62b5a5f874ab2cdcf5ef1d4
>
> Could you please re-check this dropped patch ?

Yes! I've applied it. Check that it lands nicely in -next.

Yours,
Linus Walleij
