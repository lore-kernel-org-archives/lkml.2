Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0HSUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:32:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0HSUcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:32:54 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Thu, 19 Aug 2010 22:32:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <1282057706.21419.130.camel@acb20005.ipt.aol.com> <201008192224.12309.agruen@suse.de>
In-Reply-To: <201008192224.12309.agruen@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192232.35047.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010 22:24:11 Andreas Gruenbacher wrote:
> Watching the same directory with fanotify results in:
> 
> 	.../d: pid=... open_perm
> 	.../d: pid=... open
> 	.../d: pid=... access_perm
> 	.../d: pid=... access_perm
> 	.../d: pid=... close

One more thing: the fanotify example code automatically sets ignore marks by 
default so the second access_perm check above will normally be suppressed.  
Use the -n option of the copy here to turn ignore marks off:

	http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git
