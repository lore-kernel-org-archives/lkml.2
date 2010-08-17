Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0HQGej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:34:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40240 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0HQGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fZO/xw+OP3tuLMMagEA9LjMv1so2D+KiVReg93Y3YRVWUlwjtBI36VSLHSuOkdadcf
         jJiOdiu+qx/eWHz1P+M4dEac5jcWXaWshnpUareWhSccncaDcPkfj7EKBTGdX7a5N/Bg
         ww6NgXIp3GUm/+Klcxbfz3v8/i2EyfFWMHpo0=
Date: Tue, 17 Aug 2010 09:34:45 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the sound-asoc tree with the omap
 tree
Message-Id: <20100817093445.ade1b4a4.jhnikula@gmail.com>
In-Reply-To: <20100817061558.GD12184@atomide.com>
References: <20100817122145.f399e543.sfr@canb.auug.org.au>
	<20100817061558.GD12184@atomide.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:15:59 +0300
Tony Lindgren <tony@atomide.com> wrote:

> * Stephen Rothwell <sfr@canb.auug.org.au> [100817 05:14]:
> > Hi all,
> > 
> > Today's linux-next merge of the sound-asoc tree got a conflict in
> > arch/arm/mach-omap2/board-n8x0.c between commits
> > 1c37553eb1778802f0e7b6730df36542752e801e ("omap: n8x0: Cleanup i2c1 and
> > menelaus registration") and 69be0f6f4b8e3be992ab6a333a3a82e043784c52
> > ("omap: n8x0: Register i2c2 and add board info with tlv320aic3xfor N810")
> > from the omap tree and commit f0fba2ad1b6b53d5360125c41953b7afcd6deff0
> > ("ASoC: multi-component - ASoC Multi-Component Support") from the
> > sound-asoc tree.
> > 
> > I couldn't figure this out, so I effectively reverted the part of the
> > latter commit affecting that file.  Is there no way that the latter
> > commit can be broken up into smaller self contained pieces?
> 
> Let's let Jarkko and Liam to queue these along with the other
> ASoC patches, I'll drop them from omap for-next.
> 
> Jarkko, can you please rebase them?
> 
I think it's easier if you keep them in l-o for-next and I send a
patch to ASoC multi-component removing board-n8x0.c changes.

That way the N810 audio is usable in linux-omap before m-c merge and m-c
patch touch less board files.


-- 
Jarkko
