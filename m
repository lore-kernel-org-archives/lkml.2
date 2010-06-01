Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0FAUwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:52:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0FAUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:52:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GXjdmUjvKRQJQ61fyG599YHjfCu6Jnl2qqgr8lUMPGU2Qsy+UgLdYwIRGVGX+bhrU
	eAnUfOKGxatKB5nxbldCg==
Date: Tue, 1 Jun 2010 13:52:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: dave b <db.pub.mail@gmail.com>
cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
In-Reply-To: <AANLkTil8sEzrsC9If5HdU8S5R-sK84_fUt_BXUDcAu0J@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006011351400.13136@chino.kir.corp.google.com>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> <AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com> <AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com> <alpine.LSU.2.00.1005211410170.14789@sister.anvils>
 <AANLkTil8sEzrsC9If5HdU8S5R-sK84_fUt_BXUDcAu0J@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, dave b wrote:

> That was just a simple test case with dd. That test case might be
> invalid - but it is trying to trigger out of memory - doing this any
> other way still causes the problem. I note that playing with some bios
> settings I was actually able to trigger what appeared to be graphics
> corruption issues when I launched kde applications ... nothing shows
> up in dmesg so this might just be a conflict between xorg and the
> kernel with those bios settings...
> 
> Anyway, This is no longer a 'problem' for me since I disabled
> overcommit and altered the values for dirty_ratio and
> dirty_background_ratio - and I cannot trigger it.
> 

Disabling overcommit should always do it, but I'd be interested to know if 
restoring dirty_ratio to 40 would help your usecase.
