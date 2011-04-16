Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1DPAlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:41:13 -0400
Received: from fieldses.org ([174.143.236.118]:54487 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab1DPAlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:41:11 -0400
Date: Fri, 15 Apr 2011 20:41:07 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Greg KH <gregkh@suse.de>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
        Rick Koshi <nfs-bug-report@more-right-rudder.com>,
        Ivo =?utf-8?Q?P=C5=99ikryl?= <prikryl@eurosat.cz>
Subject: Re: 2.6.38.2: regression from 2.6.38: kernel BUG at
 fs/nfsd/nfs4state.c:380!
Message-ID: <20110416004107.GC14177@fieldses.org>
References: <201103282223.06191.wolfgang.walter@stwm.de>
 <20110328203207.GA17493@suse.de>
 <201103282300.57903.wolfgang.walter@stwm.de>
 <20110328214122.GA19854@suse.de>
 <20110329031347.GC2695@fieldses.org>
 <20110329031725.GA3665@suse.de>
 <20110411081726.GB31311@fieldses.org>
 <20110412000809.GB11110@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412000809.GB11110@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 05:08:09PM -0700, Greg KH wrote:
> On Mon, Apr 11, 2011 at 04:17:26AM -0400, J. Bruce Fields wrote:
> > Argh, I forgot to stick the "Cc: stable" on this one.  Anyway, should be
> > in Linus's tree soon:
> > 
> > --b.
> > 
> > commit 23fcf2ec93fb8573a653408316af599939ff9a8e
> 
> Now picked up.
> 
> In the future, at least cc: this email to stable@kernel.org so I don't
> loose it in the wilds that are my suse.de email account...

Apologies, will do.--b.
