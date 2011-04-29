Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab1D2XA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:00:58 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:35147 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934069Ab1D2XA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:00:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ER/Wew6jr9uBZ2SIdmxmF4rNqk0D/hC27heTItaV+58DsasmCi6vcw8B/BUk892LMcv6bDW1ezd+nD6GkWfadbHQVB8DU8LfTVQcMTOxTXvbq8wncizpfSgS1pP0fjFV;
Date: Fri, 29 Apr 2011 16:00:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: <pefoley2@verizon.net>, <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to
 scripts/docproc.c
Message-Id: <20110429160053.bbe7c199.rdunlap@xenotime.net>
In-Reply-To: <20110429155915.f9059777.rdunlap@xenotime.net>
References: <4DBB3DD4.9000000@verizon.net>
	<20110429155915.f9059777.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 15:59:15 -0700 Randy Dunlap wrote:

> On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:
> 
> > This patchset moves scripts/basic/docproc to scripts/docproc.
> > This causes docproc to only be built for *doc targets rather than every
> > time the kernel is compiled.
> > 
> > Patches also attached as requested by Michal Marek.
> 
> 
> Please test & fix when using O=output_dir.

Sorry, user error.  I missed applying patch 6/7.  :(

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
