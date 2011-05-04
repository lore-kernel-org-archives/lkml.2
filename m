Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1EDXSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:18:49 -0400
Received: from kroah.org ([198.145.64.141]:33234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab1EDXSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:18:48 -0400
Date: Wed, 4 May 2011 16:11:46 -0700
From: Greg KH <greg@kroah.com>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] XZ decompressor: Fix decoding of empty LZMA2
 streams
Message-ID: <20110504231146.GF26011@kroah.com>
References: <201105011938.42851.lasse.collin@tukaani.org>
 <20110503143620.c6b4d272.akpm@linux-foundation.org>
 <201105040122.36545.lasse.collin@tukaani.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105040122.36545.lasse.collin@tukaani.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:22:36AM +0300, Lasse Collin wrote:
> On 2011-05-04 Andrew Morton wrote:
> > Lasse Collin <lasse.collin@tukaani.org> wrote:
> > > From: Lasse Collin <lasse.collin@tukaani.org>
> > > 
> > > The old code considered valid empty LZMA2 streams to be corrupt.
> > > Note that a typical empty .xz file has no LZMA2 data at all,
> > > and thus most .xz files having no uncompressed data are handled
> > > correctly even without this fix.
> > > 
> > > Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
> > 
> > The patch didn't have the cc:stable tag, but appears to be needed in
> > 2.6.38.x and perhaps earlier, yes?
> > 
> > It's commit 646032e3b05b32d3f20cb108a030593d9d792eb5 in mainline.
> 
> Thanks. It's good for 2.6.38.x. Older ones don't have XZ support.

Now queued up, thanks.

greg k-h
