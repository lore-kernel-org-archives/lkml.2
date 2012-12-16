Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2LPLfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:35:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52574 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2LPLfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:35:13 -0500
Date: Sun, 16 Dec 2012 12:35:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [regression] 3.7 ends in APIC panic
Message-ID: <20121216113505.GA25304@gmail.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB3EAB.309@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> wrote:

> On 12/13/2012 01:16 PM, Bernd Schubert wrote:
> >Hello,
> >
> > I just tried to boot 3.7 and it ends in an APIC panic. I 
> > tried to use the recommended "apic=debug", but that does not 
> > change anything in the output, at least not in the visible 
> > part. The last known kernel to boot was 3.5. If it matters I 
> > can try to boot 3.6.
> 
> So linux-3.6 also boots. Any idea what is going on or do I 
> really need to bisect?

Yeah, it's hard to tell based on that info alone - would be nice 
to send in a log/screen capture of the crash and of course 
bisecting would be useful as well, if the crash is 
deterministic.

Thanks,

	Ingo
