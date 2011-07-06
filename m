Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1GFUFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:05:03 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57643 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755800Ab1GFUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:05:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Mh2UyrSsQQ9hQ/S8r2fN6ZPcO/kPp6BecPYBxv4isVcUojC21l4MWiK9Wnl9RdFQAilQseb1/2GVn9LKmRp3+d9kXU4nBlYH5+M03h61i1ghkC49ZfxMW1cBoY3JgI6Z;
Date: Wed, 6 Jul 2011 13:04:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Fixup kerneldoc for generic_permission()
Message-Id: <20110706130458.a9d20575.rdunlap@xenotime.net>
In-Reply-To: <20110706200221.GF8334@distanz.ch>
References: <1309520691-17741-1-git-send-email-tklauser@distanz.ch>
	<20110706090014.d46bbbe3.rdunlap@xenotime.net>
	<20110706200221.GF8334@distanz.ch>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011 22:02:21 +0200 Tobias Klauser wrote:

> On 2011-07-06 at 18:00:14 +0200, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Fri,  1 Jul 2011 13:44:51 +0200 Tobias Klauser wrote:
> > 
> > > The flags parameter went away in
> > > 5c90c1601f00154f8695951469f25f33579272ed
> > 
> > What git tree is that commit ID in?
> 
> I made the patch against linux-next as of 1 July. The commit comes from
> Al Viro's vfs-2.6 tree I guess.
> 
> > This patch applies to linux-next, right?
> 
> Yup, it should. Sorry, I should have mentioned that in the subject.
> --

Thanks.  Hopefully Al will merge it.  If he misses it, please resend it
and I can merge it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
