Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2CLROr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:14:47 -0400
Received: from 1wt.eu ([62.212.114.60]:63192 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2CLROo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:14:44 -0400
Date: Mon, 12 Mar 2012 18:14:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
Message-ID: <20120312171434.GE12405@1wt.eu>
References: <20120312002046.041448832@1wt.eu> <201203121702.06598.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203121702.06598.arnd@arndb.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Mar 12, 2012 at 05:02:06PM +0000, Arnd Bergmann wrote:
> On Monday 12 March 2012, Willy Tarreau wrote:
> > 
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> > 
> > commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream
> > 
> > This just changes Kconfig rather than touching all the other files the
> > original commit did.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> 
> I think it would be useful to copy the entire description of the
> original patch here, which makes it clear why it's a good idea
> to apply this patch to 2.6.32-longterm.

It's possible it was stripped by git-am as I don't have it in the
queued patch either. I agree with you that the more info we have
in stable commits, the best. I'll recheck the original mail.

Thanks,
Willy

