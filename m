Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2GBPOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:14:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53954 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBPOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:14:45 -0400
Date: Mon, 2 Jul 2012 11:14:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 blocks up
Message-ID: <20120702151442.GB18074@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341240862.2979.23.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
> On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> > Can you tell me *which* xfstest this was blocking on?
> 
> Test 068 which runs fsstress.

Hmmm, I had just started an xfstests -g auto run using standard ext4
defaults with 3.5-rc2, and I'm not noting any problems.  And I've
gotten past test 68 w/o any problems.

Can you tell me more about your KVM config?

I'm using a 512 megs of memory and 2 CPU's under KVM, with a 5 gig
test partition running on a 5400 RPM laptop drive.

						- Ted
