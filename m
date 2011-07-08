Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1GHV7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:59:35 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:54114 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab1GHV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:59:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Lzh2kx6V8qLX330/rMc1p16sp1L7PCcVNWbJwervTuY5R7C4pQQC6ZPNvZFmrBFtG+Tw647f6j0G6w6bLTV+P/wtufi+89G4CyJWe+z5GchKXzHmFNgVDb6G+Nnyu2tn;
Date: Fri, 8 Jul 2011 14:59:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Menage <menage@google.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation:cgroups:fix a command error in
 cpuacct.txt
Message-Id: <20110708145932.d42226e6.rdunlap@xenotime.net>
In-Reply-To: <CAJniumUzXpiau2XCj=gR3Qoq7LjeVamR6krFyDgimOo27-U67g@mail.gmail.com>
References: <1310102676-23154-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<CAJniumUzXpiau2XCj=gR3Qoq7LjeVamR6krFyDgimOo27-U67g@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011 14:55:22 -0700 Paul Menage wrote:

> On Thu, Jul 7, 2011 at 10:24 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> > Must echo a task id to the cgroups' tasks file, but not to a directory.
> >
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>

Applied.

> Thanks,

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
