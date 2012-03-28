Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2C1LiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:38:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34423 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2C1LiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:38:12 -0400
Date: Wed, 28 Mar 2012 12:38:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120328113808.GB23005@sirena.org.uk>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
 <20120326161132.GA6430@lizard>
 <20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
 <20120327130350.GB7972@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327130350.GB7972@lizard>
X-Cookie: BELA LUGOSI is my co-pilot ...
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:03:50PM +0400, Anton Vorontsov wrote:

> But for such drivers I usually give my 'Acked-by' so that
> patches could be merged via single tree (i.e. mfd). But nobody
> asked me in this case.

Well, for completely new MFDs there's no need as the dependency on the
core will generally sort everything out.  It's only adding things to an
existing MFD that might have some issues.
