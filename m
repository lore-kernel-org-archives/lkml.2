Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2JZAni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:43:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57650 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab2JZAng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:43:36 -0400
Date: Thu, 25 Oct 2012 20:43:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Message-ID: <20121026004326.GB10509@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ric Wheeler <ricwheeler@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix>
 <5089D520.6020106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5089D520.6020106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 08:11:12PM -0400, Ric Wheeler wrote:
> 
> Sending this just to you two to avoid embarrassing myself if I
> misread the thread, but....
> 
> Can we reproduce this with any other hardware RAID card? Or with MD?

There was another user who reported very similar corruption using
3.6.2 using USB thumb drive.  I can't be certain that it's the same
bug that's being triggered, but the symptoms were identical.

> If we cannot reproduce this in other machines, why assume this is an
> ext4 issue and not a hardware firmware bug?
> 
> As an ex-storage guy, this really smells like the hardware raid card
> might be misleading us....

It's possible.  The main reason why I took this so seriously was
because of the 2nd, apparently confirming report, with very different
hardware.  That was what was so scary to me, at least at first.

	   	    	     	      - Ted
