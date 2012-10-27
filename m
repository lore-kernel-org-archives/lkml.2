Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab2J0Rzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:55:44 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57998 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363Ab2J0Rzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:55:43 -0400
Date: Sat, 27 Oct 2012 13:55:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nix <nix@esperi.org.uk>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Message-ID: <20121027175534.GA7783@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
References: <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508AF3FA.4020506@redhat.com>
 <87wqydx957.fsf@spindle.srvr.nix>
 <20121026205618.GC8614@thunk.org>
 <87objpx84k.fsf@spindle.srvr.nix>
 <20121026211542.GE8614@thunk.org>
 <87haphx76u.fsf@spindle.srvr.nix>
 <20121027002258.GB31030@thunk.org>
 <873910xevu.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873910xevu.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 01:45:25PM +0100, Nix wrote:
> Ah! it's turned on by journal_async_commit. OK, that alone argues
> against use of journal_async_commit, tested or not, and I'd not have
> turned it on if I'd noticed that.
> 
> (So, the combinations I'll be trying for effect on this bug are:
> 
>  journal_async_commit (as now)
>  journal_checksum
>  none

Can you also check and see whether the presence or absence of
"nobarrier" makes a difference?

Thanks,

						- Ted
