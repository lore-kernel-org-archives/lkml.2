Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0EFD5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:57:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab0EFD5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:57:06 -0400
Date: Wed, 5 May 2010 23:57:04 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tammy <tammy000@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git Bad Object
Message-ID: <20100506035704.GB4902@bombadil.infradead.org>
References: <w2s7fcc02551005052051s7c1810c1kad9cc44f3fb3ff5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w2s7fcc02551005052051s7c1810c1kad9cc44f3fb3ff5d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:51:40PM -0400, Tammy wrote:
> Hi,
> 
> I was looking at the commits in
> http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.14. Seems
> all the commits are not in the current git.
> 
> For example, if I run 'git show
> 0b7da0500bbf612fc532358c90aad4497309d61a', I got 'fatal: bad object
> 0b7da0500bbf612fc532358c90aad4497309d61a'. Why is this the case? I
> thought all these commits are committed into the git repository. Thank
> you!
> 

They aren't all in Linus' git tree, because the stable kernels are not
maintained by him, but by a team of people in another git tree.

The stable aggregate tree will have all those commits in it here:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary

regards, Kyle
