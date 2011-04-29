Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1D2Wqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:46:54 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33877 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754851Ab1D2Wqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:46:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OtWkD7HsSC6YS4XJ8j24celk2Fk0yH4RqdLzjcCtpxzJ7bgG1XSkln6AOVbtRyGD5+0PE+8VpZiukuxze+sH91K5SJs3hS7LPOb+Uh3VKNPN0AMTyUBqYnjLNDA/F+69;
Date: Fri, 29 Apr 2011 15:46:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: <pefoley2@verizon.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to
 scripts/docproc.c
Message-Id: <20110429154649.848f9ba8.rdunlap@xenotime.net>
In-Reply-To: <4DBB3DD4.9000000@verizon.net>
References: <4DBB3DD4.9000000@verizon.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:

> This patchset moves scripts/basic/docproc to scripts/docproc.
> This causes docproc to only be built for *doc targets rather than every
> time the kernel is compiled.
> 
> Patches also attached as requested by Michal Marek.


That's disappointing (the attachments).  Why was this requested?

See Documentation/CodingStyle, section 7:

"No MIME, no links, no compression, no attachments.  Just plain text."


It also causes breakage in other people's patch merging/testing.
E.g., I cannot save any one of these emails as I can with other patches
and get a useful patch file.  Instead, the saved file contains lines like
this (below) and each patch 2 times (inline and attachment).

--------------060706070408040606010200
Content-Type: text/plain;
	name="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-DocBook-Makefile-in-preperation-for-mo.patch"



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
