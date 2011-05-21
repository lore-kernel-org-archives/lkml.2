Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1EUVoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 17:44:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1EUVoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 17:44:22 -0400
Date: Sat, 21 May 2011 14:43:52 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [23/71] tmpfs: fix race between umount and swapoff
Message-ID: <20110521214352.GA5912@suse.de>
References: <20110519180556.482988919@clark.kroah.org>
 <alpine.LSU.2.00.1105202139001.1847@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105202139001.1847@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 09:48:26PM -0700, Hugh Dickins wrote:
> On Thu, 19 May 2011, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 
> Witold has found that I screwed up the highmem case in this patch.
> Please add the commit appended at the bottom - or else delay both
> until the next 2.6.38-stable if you prefer.

Ok, I've queued this one up as well.

thanks,

greg k-h
