Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1KQOdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:33:38 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48744 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757659Ab1KQOdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:33:37 -0500
Date: Thu, 17 Nov 2011 14:33:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Rene Bolldorf <xsecute@googlemail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Initial PCI support for Atheros 724x SoCs. (v2)
Message-ID: <20111117143331.GE20183@linux-mips.org>
References: <CAEWqx59k97AMU6hH0NCC2TMEY2mu8d5ytxO68oEsa=7uvLBA4A@mail.gmail.com>
 <1321538577-548-1-git-send-email-xsecute@googlemail.com>
 <1321538577-548-2-git-send-email-xsecute@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321538577-548-2-git-send-email-xsecute@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 03:02:56PM +0100, Rene Bolldorf wrote:

Queued for 3.3 but:

> Subject: [PATCH 1/2] Initial PCI support for Atheros 724x SoCs. (v2)

Please don't put the (v2) at the end of the subject line but rather into
the initial part with the square brackets like:

Subject: [PATCH 1/2, v2] Initial PCI support for Atheros 724x SoCs.

That's so software like git-am will automatically discard that when
applying a patch.

Your use of non-ASCII characters is not quite yet supported in patchwork,
see:

  http://patchwork.linux-mips.org/patch/3019/
  http://patchwork.linux-mips.org/patch/3020/

My surname's spelling  is also suffering from ASCII brain damaged software ...

> +	switch (size) {
> +	case 1:
> +		addr = where & ~3;
> +		mask = 0xff000000 >> ((where % 4) * 8);
> +		tval = reg_read(ATH724X_PCI_DEV_BASE + addr);
> +		tval = tval & ~mask;
> +		*value = (tval >> ((4 - (where % 4))*8));
> +	break;
> +	case 2:

That's a very odd style of formatting.  The Linux coding style (see
Documentation/) wants the break keyword indented with the same number
of tabs as the preceeding block.

Anyway, I took care of that.

Thanks,

  Ralf
