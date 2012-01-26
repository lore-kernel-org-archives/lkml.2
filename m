Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2AZS3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:29:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2AZS3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:29:03 -0500
Date: Thu, 26 Jan 2012 19:28:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] MCE recovery changes
Message-ID: <20120126182842.GA8630@elte.hu>
References: <4f1f396019579c94fb@agluck-desktop.sc.intel.com>
 <20120126104646.GF3853@elte.hu>
 <CA+8MBbKyoM330hL830PtUz9+EVxkxVVyHcL_PbN+zYRs-BXQiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+8MBbKyoM330hL830PtUz9+EVxkxVVyHcL_PbN+zYRs-BXQiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> On Thu, Jan 26, 2012 at 2:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > It worked perfectly.
> 
> Hurrah!
> 
> > Pulled, thanks!
> 
> Thank you.
> 
> > One thing i noticed was the magic constant 0x134:
> >
> > +               SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
> >
> > don't we want that defined a bit more clearly?
> 
> Stylistically it is compatible with the existing:
> MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
> and
> MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
> 
> ... but that's just a sign that they need some love too :-)
> 
> I'll see what I can do - but meaningful names will clearly be 
> longer than the hex constants that they replace - and I'm 
> already pushing line length limits here, so it will need more 
> than a trivial restructure.

Well, one option is to let the line grow - for such things it's 
ok up to 100 cols or so.

Thanks,

	Ingo
