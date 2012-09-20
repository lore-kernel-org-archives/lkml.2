Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2ITRls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:41:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57061 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2ITRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:41:47 -0400
Date: Thu, 20 Sep 2012 10:41:41 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] vfs: define getname_info struct and have
 getname() return it
Message-ID: <20120920174141.GD19073@ghostprotocols.net>
References: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
 <1348150999-13028-5-git-send-email-jlayton@redhat.com>
 <20120920164448.GA19073@ghostprotocols.net>
 <20120920100047.7f37f660@corrin.poochiereds.net>
 <20120920173645.GB19073@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920173645.GB19073@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 20, 2012 at 10:36:45AM -0700, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Sep 20, 2012 at 10:00:47AM -0700, Jeff Layton escreveu:
> > You may find it easier to just pull down the "estale" branch in my tree
> > and pop off the patches for the estale series itself.
> 
> What tree? Couldn't find any on git.kernel.org.

Ok, I guess this one:

http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/estale

- Arnaldo
