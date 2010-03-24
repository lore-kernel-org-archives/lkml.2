Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0CXAVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:21:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0CXAVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:21:20 -0400
Date: Wed, 24 Mar 2010 00:21:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100324002117.GN30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
 <20100323142843.GG30031@ZenIV.linux.org.uk>
 <20100323143456.GC2381@localhost.localdomain>
 <20100323144828.GH30031@ZenIV.linux.org.uk>
 <20100323150301.GD2381@localhost.localdomain>
 <20100323150923.GI30031@ZenIV.linux.org.uk>
 <4BA94157.6090907@crca.org.au>
 <20100323231802.GL30031@ZenIV.linux.org.uk>
 <4BA95454.1080400@crca.org.au>
 <4BA95501.4000806@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA95501.4000806@crca.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:55:45AM +1100, Nigel Cunningham wrote:
> Hi again.
> 
> On 24/03/10 10:52, Nigel Cunningham wrote:
> >>I've stayed away from TuxOnIce flamefests and I've no idea how
> >>representative
> >>that snippet is, but if it *does* match the general code quality in
> >>there...
> >>Ouch.
> >
> >Locking isn't necessary because of the freezing.
> 
> Err, freezer, I mean.

Even leaving aside the accuracy of that (and I seriously doubt it), this
is completely wrong since *code* *gets* *copied*.
