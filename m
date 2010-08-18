Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0HROSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:18:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab0HROSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:18:31 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Wed, 18 Aug 2010 16:18:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008171038.50456.agruen@suse.de> <1282058668.21419.131.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282058668.21419.131.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181618.14533.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 17:24:28 Eric Paris wrote:
> On Tue, 2010-08-17 at 10:38 +0200, Andreas Gruenbacher wrote:
> > On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> > > On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > > > 	[1] http://people.redhat.com/~eparis/fanotify/
> > 
> > Oh ... this example doesn't actually build; both syscall prototypes are
> > wrong. What have you been testing this with?
> 
> I updated that code, I didn't realize just how out of date it got.

Thanks.  Please grab some cleanups from here:

	http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git

Andreas
