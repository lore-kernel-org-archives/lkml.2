Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2J2Cmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:42:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58213 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab2J2Cma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:42:30 -0400
Date: Sun, 28 Oct 2012 22:42:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Message-ID: <20121029024224.GD9365@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
References: <20121027002258.GB31030@thunk.org>
 <873910xevu.fsf@spindle.srvr.nix>
 <20121027175534.GA7783@thunk.org>
 <87fw4zzra3.fsf@spindle.srvr.nix>
 <508C4FE5.1030102@redhat.com>
 <508C633F.4070100@redhat.com>
 <20121029010012.GE9161@thunk.org>
 <508DE8D3.1050101@redhat.com>
 <20121029023430.GB9365@thunk.org>
 <508DEB8E.10101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508DEB8E.10101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 09:35:58PM -0500, Eric Sandeen wrote:
> Yeah, seems that way.
> 
> Then your simpler version is probably the way to go.

If you have a chance, could you do me a favor and test my -v3 version
of the patch?  It should work just as well as yours, but I'm getting
paranoid in my old age, and you seem to have a reliable way of testing
for this failure.  I still need to figure out why my kvm based
approach isn't showing the problem....

Thanks,

-- Ted
