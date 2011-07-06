Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1GFUCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:02:23 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:44754 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab1GFUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:02:22 -0400
Date: Wed, 6 Jul 2011 22:02:21 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Fixup kerneldoc for generic_permission()
Message-ID: <20110706200221.GF8334@distanz.ch>
References: <1309520691-17741-1-git-send-email-tklauser@distanz.ch> <20110706090014.d46bbbe3.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706090014.d46bbbe3.rdunlap@xenotime.net>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-06 at 18:00:14 +0200, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Fri,  1 Jul 2011 13:44:51 +0200 Tobias Klauser wrote:
> 
> > The flags parameter went away in
> > 5c90c1601f00154f8695951469f25f33579272ed
> 
> What git tree is that commit ID in?

I made the patch against linux-next as of 1 July. The commit comes from
Al Viro's vfs-2.6 tree I guess.

> This patch applies to linux-next, right?

Yup, it should. Sorry, I should have mentioned that in the subject.
