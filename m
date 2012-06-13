Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2FMWG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:06:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48829 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2FMWGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:06:54 -0400
Date: Thu, 14 Jun 2012 00:06:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boszormenyi Zoltan <zboszor@pr.hu>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
Message-ID: <20120613220651.GA12065@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boszormenyi Zoltan <zboszor@pr.hu>,
	Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <4FD4F45D.5050103@pr.hu>
 <20120611084318.GA1685@liondog.tnic>
 <20120611094905.GA10349@liondog.tnic>
 <20120611110557.GA4599@sig21.net>
 <4FD8417B.8020702@pr.hu>
 <20120613155733.GA17726@liondog.tnic>
 <4FD8DB3F.7050106@pr.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD8DB3F.7050106@pr.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:26:07PM +0200, Boszormenyi Zoltan wrote:
> I did exactly that, the remaining two 8GB modules don't have faults
> according to memtest86+ and the machine is stable with "make -j8" in
> the kernel tree. Neither thunderbird nor firefox crashed for a day,
> these are the usual victims when hitting the bad memory address.

Cool.

I guess you could try to limit it even further by taking a known-good
8GB module and pairing it with one of the "bad" ones to see whether one
of the "bad" 8GB modules is faulty or both of them are.

Or you could stop wasting time and go buy two new ones :-)

-- 
Regards/Gruss,
    Boris.
