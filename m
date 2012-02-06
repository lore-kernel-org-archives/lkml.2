Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2BFVyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:54:06 -0500
Received: from longford.logfs.org ([213.229.74.203]:56160 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BFVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:54:05 -0500
Date: Mon, 6 Feb 2012 15:13:22 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>
Subject: Re: Announce: cancd 0.2.0 netconsole capture server
Message-ID: <20120206201322.GB8068@logfs.org>
References: <20120206190206.GA8068@logfs.org>
 <x49mx8vps2l.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49mx8vps2l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 February 2012 16:31:14 -0500, Jeff Moyer wrote:
> 
> Hmm, the old netdump-server package that we used to ship in RHEL should
> work too, I think, if you are interested in that approach.  That was
> designed specifically to receive netconsole messages and netdumps from
> multiple servers.  Google up netdump-server-0.7.16 and you should find
> an srpm.  If there's interest in keeping that alive, I can put it up in
> some public repo.

Interesting.  Not sure whether I care about keeping it alive, but
having a peek at the source cannot hurt.

I wonder how many more parallel efforts are out there.

Jörn
