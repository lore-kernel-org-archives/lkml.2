Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab1D2XCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:02:16 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:49013 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934080Ab1D2XCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:02:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=atvPXB0dGlf/4jKB5BSo0obYE2zou3hR/WDT6G8Pmn6JdwriJ4eDX5fzG9jjjCtKEDQbncTMTYuS6r9R8Q3/dZINvVwbWEfjSHmRTs/248ru8eCHiuPPCEJesp5Nls8G;
Date: Fri, 29 Apr 2011 16:02:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: pefoley2@verizon.net, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to
 scripts/docproc.c
Message-Id: <20110429160212.6662c08a.rdunlap@xenotime.net>
In-Reply-To: <4DBB42F9.7070407@suse.cz>
References: <4DBB3DD4.9000000@verizon.net>
	<20110429154649.848f9ba8.rdunlap@xenotime.net>
	<4DBB42F9.7070407@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 01:00:09 +0200 Michal Marek wrote:

> On 30.4.2011 00:46, Randy Dunlap wrote:
> > On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:
> > 
> >> This patchset moves scripts/basic/docproc to scripts/docproc.
> >> This causes docproc to only be built for *doc targets rather than every
> >> time the kernel is compiled.
> >>
> >> Patches also attached as requested by Michal Marek.
> > 
> > 
> > That's disappointing (the attachments).  Why was this requested?
> > 
> > See Documentation/CodingStyle, section 7:
> > 
> > "No MIME, no links, no compression, no attachments.  Just plain text."
> 
> and a couple of lines later:
> "Exception:  If your mailer is mangling patches then someone may ask
> you to re-send them using MIME."
> 
> Which is exactly what happened here - the patches had missing or excess
> leading space and in some cases a context line was missing. So instead
> of manually reconstructing the patches, I asked Peter to resend them as
> attachments.

OK, thanks for explaining.

> BUT - I didn't request to split this patch into seven pieces. Splitting
> patches into smaller parts is desired, but each part has to be self
> contained and not break stuff when the later parts are not applied. So
> when moving a .c file, then the corespoding Makefile changes need to be
> contained in the same patch. No need to resend the patch now, I'll fold
> the patches into one again, but please consider this next time.

Yes, a few of them could be merged IMO.

> > Instead, the saved file contains lines like
> > this (below) and each patch 2 times (inline and attachment).
> 
> Yeah, only sending the attachment would be better in this case.

agreed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
