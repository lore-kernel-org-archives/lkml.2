Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320Ab1KJEJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:09:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45113 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab1KJEJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:09:10 -0500
MIME-Version: 1.0
In-Reply-To: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
Date: Thu, 10 Nov 2011 12:09:08 +0800
Message-ID: <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Nai Xia <nai.xia@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Did this patch get merged at last, or on this way being merged, or
just dropped ?

Thanks,

Nai

On Tue, Apr 12, 2011 at 2:10 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Benjamin, Hugh, I hope to add your S-O-B to this one because you are original author.
> Can I do?
>
> Paul, Russell, This patch modifies arm and sh code a bit. I don't think
> they are risky change. but I'm really glad if you see it.
>
>
> Note: I confirmed x86, power and nommu-arm cross compiler build and
> I've got no warning/error.
>
>
>
> From d5a0d1c265e4caccb9ff5978c615f74019b65453 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 12 Apr 2011 14:00:42 +0900
> Subject: [PATCH] mm: convert vma->vm_flags to 64bit
>
> For years, powerpc people repeatedly request us to convert vm_flags
> to 64bit. Because now it has no room to store an addional powerpc
> specific flags.
>
> Here is previous discussion logs.
>
>        http://lkml.org/lkml/2009/10/1/202
>        http://lkml.org/lkml/2010/4/27/23
>
> But, unforunately they didn't get merged. This is 3rd trial.
> I've merged previous two posted patches and adapted it for
> latest tree.
>
> Of cource, this patch has no functional change.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
