Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1LMSxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:53:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:38769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1LMSxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:53:04 -0500
Message-ID: <1323802323.9082.20.camel@twins>
Subject: Re: [PATCH 1/3] kref: Inline all functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Date: Tue, 13 Dec 2011 19:52:03 +0100
In-Reply-To: <20111213171511.GA17096@kroah.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.107647845@chello.nl> <20111212221159.GA27940@kroah.com>
	 <1323768980.9082.6.camel@twins> <20111213171511.GA17096@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 09:15 -0800, Greg KH wrote:

> > ---
> >  include/linux/kref.h |   80 +++++++++++++++++++++++++++++++++++++++---
> >  lib/Makefile         |    2 -
> >  lib/kref.c           |   97 ---------------------------------------------------
> >  3 files changed, 76 insertions(+), 103 deletions(-)
> > Index: linux-2.6/include/linux/kref.h
> > ===================================================================
> 
> What's this stuff for, we aren't using cvs anymore :)

Dunno, it looks like quilt generates that for me.
