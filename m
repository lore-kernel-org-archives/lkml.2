Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0FIULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:11:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60164 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0FIULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:11:35 -0400
Date: Wed, 9 Jun 2010 21:11:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       platform-driver-x86@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Daniel Oliveira Nascimento <don@syst.com.br>
Subject: Re: [PATCH -next] classmate-laptop: fix for RFKILL=m, CMPC=y
Message-ID: <20100609201118.GA27593@srcf.ucam.org>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <20100603093903.d9378c9a.randy.dunlap@oracle.com> <20100609200218.GD2551@barata.holoscopio.com> <4C0FF3F0.2080601@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0FF3F0.2080601@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 01:05:04PM -0700, Randy Dunlap wrote:
> On 06/09/10 13:02, Thadeu Lima de Souza Cascardo wrote:
> > Since this implies a build failure, shouldn't it be sent for rc too?
> 
> Yes, it should.
> I hit the problem during a linux-next build, but it does apply to mainline as well.
> Thanks.

It's been sent upstream, but Linus didn't pull. I'll see if I can find a 
set he's willing to take.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
