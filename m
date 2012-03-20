Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab2CTNio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:38:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44059 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2CTNim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120313131616.f66dbdad.akpm@linux-foundation.org>
References: <4F57A3EC.7070101@gmail.com>
	<1331660076-32766-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120313131616.f66dbdad.akpm@linux-foundation.org>
Date: Tue, 20 Mar 2012 19:08:39 +0530
Message-ID: <CAAHN_R3mFzmtCey_0JEHp=EAGh1sb87szpsKD_JkFwwYLCnKug@mail.gmail.com>
Subject: Re: [PATCH] -mm/linux-next: procfs: Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-next <linux-next@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jamie Lokier <jamie@shareable.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Mike Frysinger <vapier@gentoo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 1:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 23:04:36 +0530
> Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:
>
>> Following is the updated patch with requested changes incorporated.
>
> Boy, that's a lot of changes (below).  What does it all do?
>

Hi,

Since this patch was included in the -mm tree on March 14th, I assumed
that linux-next would get the patch in today's merge, but it hasn't.
Is there something I am missing? Does the patch need additional
review/acks that I need to request for?

Thanks,
Siddhesh

Thanks,
Siddhesh


-- 
Siddhesh Poyarekar
http://siddhesh.in
