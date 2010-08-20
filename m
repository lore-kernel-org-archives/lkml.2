Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0HTOne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:43:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44000 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0HTOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:43:32 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 05/13] vfs: Support null pathname in readlink
In-Reply-To: <20100820083213.GB10039@infradead.org>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083213.GB10039@infradead.org>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 20 Aug 2010 20:13:14 +0530
Message-ID: <m38w41s5tp.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 04:32:13 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Changing the interfaces of existing system calls to accept a NULL name
> which previously wasn't acceptable is not valid.  Even for new system
> calls I think it's a bad idea.  utimensat already has the most ugly
> code of all fs related system calls because of that.
> 

But from an interface point, it seems nice to say if the relative name
from an fd is NULL, the operation should happen on fd itself.

-aneesh
