Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2IXOzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:55:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2IXOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:55:49 -0400
Date: Mon, 24 Sep 2012 09:55:34 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] userns: Convert hostfs to use kuid and kgid where
 appropriate
Message-ID: <20120924145534.GA5193@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-5-git-send-email-ebiederm@xmission.com>
 <505F864C.2000103@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505F864C.2000103@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Weinberger (richard@nod.at):
> Am 21.09.2012 02:28, schrieb Eric W. Biederman:
> > From: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > Cc: Jeff Dike <jdike@addtoit.com>
> > Cc: Richard Weinberger <richard@nod.at>
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> 
> Looks sane to me.
> 
> Acked-by: Richard Weinberger <richard@nod.at>
> 
> BTW: How you do test your user namespace patches?

I've got a few specific tests of the new functionality in the usernstest.c
in the nsexec package at
https://launchpad.net/~serge-hallyn/+archive/userns-natty/+sourcepub/2530252/+listing-archive-extra .
Of course LTP already has a good set of test cases for the regular
functionality.

> Is there a generic way to compare/verify uids within a namespace vs. the initial namespace?

It's good to look at output of 'id' in the task versus 'ps' from the initial ns,
as well as create a file and look at the stat output from both namespaces.

-serge
