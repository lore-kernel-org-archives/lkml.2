Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2LJHjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:39:41 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52427 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2LJHjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:39:40 -0500
Message-ID: <50C591B0.10408@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 15:39:28 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: TIP tree's master branch failed to boot up
References: <50C56A13.9040604@linux.vnet.ibm.com>
In-Reply-To: <50C56A13.9040604@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121007-0260-0000-0000-00000245FFEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 12:50 PM, Michael Wang wrote:
> Hi, Folks
> 
> I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
> failed to boot up my server, it's hung at very beginning and I could not
> catch any useful log, is there any one else got this problem or I'm the
> only one?.

And bisect catch below commit:

commit 56e7dba100a50f674627a3764fd4da4a6ec93295
Merge: ea8432f 16544f8
Author: Ingo Molnar <mingo@kernel.org>
Date:   Fri Dec 7 12:13:11 2012 +0100

    Merge branch 'x86/microcode'

Regards,
Michael Wang


> 
> Regards,
> Michael Wang
> 

