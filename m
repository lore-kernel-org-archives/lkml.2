Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab0EYOGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:06:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab0EYOGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:06:30 -0400
Date: Tue, 25 May 2010 07:06:05 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [01/34] ipv4: udp: fix short packet and bad checksum logging
Message-ID: <20100525140605.GA5515@suse.de>
References: <20100524230349.439835687@clark.site>
 <87zkzoqwz8.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zkzoqwz8.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 09:08:59AM +0200, Bjørn Mork wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Bjørn Mork <bjorn@mork.no>
> >
> > commit ccc2d97cb7c798e785c9f198de243e2b59f7073b upstream.
> 
> This is already in 2.6.34 AFAIK.

Yes, sorry, that should have said '2.6.32-stable review patch' above :(

thanks,

greg k-h
