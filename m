Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1CUR7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:59:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1CUR7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:59:38 -0400
Date: Mon, 21 Mar 2011 18:59:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [build failure] Re: [GIT PULL] First round of SCSI updates for
 2.6.38 merge window
Message-ID: <20110321175934.GA4849@elte.hu>
References: <1300392635.17266.5.camel@mulgrave.site>
 <20110321122111.GA17237@elte.hu>
 <1300725211.10634.20.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300725211.10634.20.camel@mulgrave.site>
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


* James Bottomley <James.Bottomley@suse.de> wrote:

> On Mon, 2011-03-21 at 13:21 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@suse.de> wrote:
> > 
> > > This represents the usual round of driver updates (fcoe, lpfc,
> > qla2xxx, > zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa)
> > plus one new > driver (bnx2fc) and as a bonus we move libsas from the
> > old libata eh to > the new one paving the way for junking the old one
> > (once we can get ipr > converted).
> > 
> > The new bnx2fc driver does not build with module support disabled:
> > 
> >  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:17: error: dereferencing
> > pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:28:
> > error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> >   drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:17: error: dereferencing
> > pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:28:
> > error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> > 
> > and this build breakage has been reported to you two weeks ago:
> > 
> >  http://lkml.org/lkml/2011/3/2/468
> 
> The actual fix is here:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e81460b20107ae83a7541d12b14114ea731a86fc

This too does the trick.

Thanks,

	Ingo
