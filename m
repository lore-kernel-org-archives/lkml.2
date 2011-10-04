Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1JDHPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:15:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab1JDHPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:15:17 -0400
Date: Tue, 4 Oct 2011 09:15:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: <4E8A910D.6020107@zytor.com>
Message-ID: <alpine.LNX.2.00.1110040912550.31654@pobox.suse.cz>
References: <4E8655CD.90107@zytor.com> <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz> <20111003225651.GA10257@leaf> <20111004044914.GP6684@thunk.org> <4E8A910D.6020107@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, H. Peter Anvin wrote:

> By the way, I'm now pretty convinced that allowing inbound ssh on
> laptops (which is the default on all the mainline Linux distros as far
> as I know) is seriously broken... laptops get connected to *extremely*
> insecure networks on just way too regular a basis.

Well, not all mainline Linux distributions do this. opensuse, to name one 
example, by default does not start sshd (and there have been quite some 
flames when this has been introduced :) ).

-- 
Jiri Kosina
SUSE Labs
