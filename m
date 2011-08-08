Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1HHTSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1HHTS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:18:29 -0400
Date: Mon, 8 Aug 2011 15:17:31 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, James Bottomley <JBottomley@Parallels.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
Message-ID: <20110808191731.GA8075@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@suse.de>,
	James Bottomley <JBottomley@Parallels.com>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
References: <20110806000251.682788533@clark.kroah.org>
 <1312739411.2591.1026.camel@deadeye>
 <1312739484.2591.1027.camel@deadeye>
 <20110808170424.GB27419@suse.de>
 <20110808181011.GE29924@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808181011.GE29924@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 07:10:11PM +0100, Ben Hutchings wrote:
 
 > > > > This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.
 > > > 
 > > > That is, AFAIK.
 > > 
 > > Oops, good catch, I've dropped this from the .32 and .33 queue now, it's
 > > not needed there at all.
 >  
 > Well, it is entirely possible that I am confusing multiple bugs (I
 > actualy attempted to delete this message from my outgoing mail queue
 > as I was becoming less confident about it).  I assume James can
 > confirm one way or the other.

fwiw, we only started seeing the bugs that this fixed in Fedora from 2.6.38.x onwards.
Our previous shipped kernel was 2.6.35, which never seemed to have any of
those problems.

	Dave

