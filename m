Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab0CPSeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:34:07 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48205 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752728Ab0CPSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:34:04 -0400
Date: Tue, 16 Mar 2010 21:34:00 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Vrabel <david.vrabel@csr.com>,
       Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend 0/3] sdhci-pltfm: Few additions and enhancements
Message-ID: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 11:11:00PM +0300, Anton Vorontsov wrote:
> On Fri, Feb 19, 2010 at 07:55:30PM +0000, David Vrabel wrote:
> > Anton Vorontsov wrote:
> > > Some hosts (e.g. as found in CNS3xxx SOCs) report wrong value in
> > > CLOCK_BASE capability field, and currently there is no way to
> > > force the SDHCI core to use the platform-provided base clock value.
> > 
> > I don't think this needs a new quirk. Change the sdhci driver to check
> > if the platform provides a value before reading the standard register.
> 
> Well, Pierre once said that by default we should conform to the
> SDHCI spec, and any diviations from the spec should be handled by
> the quirks:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-02/msg03385.html
> 
> Spec clearly states that base clock == 0 is the case when we should
> fall back to the platform-provided clocks.

No further comments, resending the patches...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
