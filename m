Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0IYMA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 08:00:27 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:33905 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755335Ab0IYMA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 08:00:26 -0400
Date: Sat, 25 Sep 2010 14:00:23 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-pcmcia@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Add an utility to parse CIS files to readable form
Message-ID: <20100925120023.GA4223@isilmar-3.linta.de>
Mail-Followup-To: Wolfram Sang <w.sang@pengutronix.de>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	linux-pcmcia@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com> <1285346965-23499-5-git-send-email-dbaryshkov@gmail.com> <20100925073342.GA31947@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925073342.GA31947@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Sep 25, 2010 at 09:33:42AM +0200, Wolfram Sang wrote:
> On Fri, Sep 24, 2010 at 08:49:24PM +0400, Dmitry Eremin-Solenikov wrote:
> > Import from pcmcia-cs project a dump_cis utility. It reads
> > machine-readable CIS file and output text representation (which can be
> > processed by mkcis utility).
> > 
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> 
> pcmciautils also include dump_cis ("make debugtools"). As this version is
> probably better maintained, we probably should not introduce a split here?

dump_cis did not receive a single meaningful change, and I do not expect
one, so I wouldn't fear a split/fork here.

Best,
	Dominik
