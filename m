Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab2FHUGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:06:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48602 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617Ab2FHUF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:05:59 -0400
Date: Fri, 8 Jun 2012 16:05:53 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
Message-ID: <20120608200553.GA1704@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Tao Ma <boyu.mt@taobao.com>, Greg KH <gregkh@linuxfoundation.org>
References: <20120607040345.775333506@linuxfoundation.org>
 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
 <20120608031144.GA9722@thunk.org>
 <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:21:48AM +0100, Ben Hutchings wrote:
> 
> It's not harmless because the user is no longer restricted to changing
> EXT4_FL_USER_MODIFIABLE.

Um, very good point.  So we should either drop this commit and wait
until the next stable release, or also pull commit b22b1f178f6 in as
well.  Basically, this commit and b22b1f178f6 should appear in the
same stable release.

						- Ted
