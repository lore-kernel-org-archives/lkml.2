Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1BDQRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:17:10 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.10.84]:1477 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1BDQRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:17:08 -0500
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
To: carlos@systemhalted.org (Carlos O'Donell)
Date: Fri, 4 Feb 2011 11:17:06 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: dave.anglin@nrc-cnrc.gc.ca, mroos@linux.ee, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim9oXFf7ksuj9o-g2J4aL4xi-JPH3PsayMayxMt@mail.gmail.com> from "Carlos O'Donell" at Feb 4, 2011 10:20:05 am
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20110204161706.B544B4DF4@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is possibly the infamous COW bug.
> 
> The COW bug that is triggered by a COW from an LWS-CAS? The solution
> to which is to use locks around the LWS-CAS even on UP? I'd forgotten
> about this issue actually, I should push that patch out to James.

I was actually thinking of the fork/clone race for which there are various
testcases on the wiki.  The aptitude segv is with a SMP kernel, so I don't
think this is the UP LWS_CAS issue.  However, I agree you should push
the change.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
