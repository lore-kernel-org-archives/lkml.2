Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2JGGV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 02:21:58 -0400
Received: from 1wt.eu ([62.212.114.60]:36005 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2JGGV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 02:21:57 -0400
Date: Sun, 7 Oct 2012 08:21:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Brian Foster <bfoster@redhat.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 110/180] ext4: dont let i_reserved_meta_blocks go negative
Message-ID: <20121007062143.GH22618@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225202.266707400@1wt.eu> <20121004215528.GK13292@decadent.org.uk> <506ECB8F.80509@redhat.com> <1349574442.16173.82.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349574442.16173.82.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 02:47:22AM +0100, Ben Hutchings wrote:
(...)
> > > This seems to be working around a bug elsewhere.  Has the underlying
> > > bug been fixed in mainline yet?
> > > 
> > 
> > Yes, the bug was fixed in:
> > 
> > 03179fe92318e7934c180d96f12eff2cb36ef7b6
> > ext4: undo ext4_calc_metadata_amount if we fail to claim space
> 
> OK, and that's been applied to stable as:
> 
> 3.2: d9af293 ext4: undo ext4_calc_metadata_amount if we fail to claim space
> 3.4: c0ce1fd ext4: undo ext4_calc_metadata_amount if we fail to claim space
> 3.5: 564dfa3 ext4: undo ext4_calc_metadata_amount if we fail to claim space
> 
> Presumably it will need some backporting for older versions.

OK. I have checked the code, and it changed significantly since. I can
still see the logic there, but function names and calculations differ,
so I'd rather defer this patch for next version.

Willy

