Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1EBAHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 20:07:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab1EBAHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 20:07:01 -0400
Date: Sun, 1 May 2011 17:11:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, brgerst@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, suresh.b.siddha@intel.com,
        eranian@google.com, robert.richter@amd.com, Andreas.Herrmann3@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fork: avoid weak function arch_dup_task_struct
Message-Id: <20110501171149.9a9342fc.akpm@linux-foundation.org>
In-Reply-To: <4DBDE5C0.1030907@zytor.com>
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
	<1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com>
	<20110501122559.bbf91079.akpm@linux-foundation.org>
	<4DBDE5C0.1030907@zytor.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 May 2011 15:59:12 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/01/2011 12:25 PM, Andrew Morton wrote:
> > On Wed, 27 Apr 2011 16:26:35 +0200 Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > 
> >> Avoid potential gcc bug by not using a weak function for
> >> arch_dup_task_struct. Use an #ifdef'ed static function for
> >> archs that don't have a special arch_dup_task_struct implementation.
> > 
> > The patch is unreviewable (and hence unusable) if you don't describe
> > this "potential gcc bug".
> >
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3202.html
> 

gcc-4.1.0 and 4.1.1 were explicitly banned via a test in
include/linux/compiler-gcc4.h for this reason.

