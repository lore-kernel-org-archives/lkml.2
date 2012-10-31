Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab2JaRp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:45:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40974 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2JaRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:25 -0400
Date: Wed, 31 Oct 2012 17:45:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031174520.GB19043@srcf.ucam.org>
References: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
 <20121031170334.59833fb1@pyramind.ukuu.org.uk>
 <20121031171048.GA17163@srcf.ucam.org>
 <20121031172121.14cc1215@pyramind.ukuu.org.uk>
 <20121031171743.GA17652@srcf.ucam.org>
 <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
 <20121031173750.GB18615@srcf.ucam.org>
 <20121031174919.51f1518d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031174919.51f1518d@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:49:19PM +0000, Alan Cox wrote:
> On Wed, 31 Oct 2012 17:37:50 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > What S4 resume check?
> 
> One you would add .. but no I'm wrong there - its a problem at the
> suspend point so you do need a signature for it. Oh well yet another
> reason it's nto useful.

Right. Hence the idea of a protected keystore at boot time. We can do 
this securely, but it does involve writing code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
