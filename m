Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2LDOUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:20:46 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63288 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2LDOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:20:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121204111006.23758.22102.stgit@localhost.localdomain>
References: <20121204111006.23758.22102.stgit@localhost.localdomain>
Date: Tue, 4 Dec 2012 09:20:41 -0500
Message-ID: <CACLa4psccEppztVNBAvXBFwvMBaOfsJWbrw7u39x1iT0D6o8sA@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: connect to UNIX sockets synchronously
From: Eric Paris <eparis@parisplace.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 6:10 AM, Stanislav Kinsbursky
<skinsbursky@parallels.com> wrote:

> But there should be noted, that such implementation introduces limitation
> (Trond's quote):
> "That approach can fall afoul of the selinux restrictions on the process
> context. Processes that are allowed to write data, may not be allowed to
> create sockets or call connect(). That is the main reason for doing it
> in the rpciod context, which is a clean kernel process context."

So you tested this and Trond was wrong?  This work just fine even on
an SELinux box?  Or it does break tons and tons of people's computers?

-Eric
