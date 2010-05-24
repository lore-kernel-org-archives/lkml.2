Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0EXX0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:26:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534Ab0EXX0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:26:12 -0400
Date: Mon, 24 May 2010 16:26:00 -0700
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [19/34] x86, k8: Fix build error when K8_NB is disabled
Message-ID: <20100524232600.GA18139@suse.de>
References: <20100524230351.044290356@clark.site>
 <4BFB0825.4090003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFB0825.4090003@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:13:41PM -0700, H. Peter Anvin wrote:
> On 05/24/2010 03:59 PM, Greg KH wrote:
> > 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > commit ade029e2aaacc8965a548b0b0f80c5bee97ffc68 upstream.
> > 
> 
> Objection only that this is already in 2.6.34.

Same thing here, sorry, I should have said .32.

too many kernel versions...

greg k-h
