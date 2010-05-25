Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0EYDg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 23:36:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab0EYDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 23:36:57 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=4ERTW0lRcqgA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=LRNRf81RRmkgUL1l7jMA:9 a=hombTs-K5JDvkik8kQ5acpLe-XkA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] xfs: convert more trace events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4BFA3815.7070000@cn.fujitsu.com>
References: <4BFA3815.7070000@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 24 May 2010 23:36:54 -0400
Message-ID: <1274758614.22648.205.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS, and save ~15K:
> 
>    text    data     bss     dec     hex filename
>  171949   43028      48  215025   347f1 fs/xfs/linux-2.6/xfs_trace.o.orig
>  156521   43028      36  199585   30ba1 fs/xfs/linux-2.6/xfs_trace.o
> 
> No change in functionality.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/xfs/linux-2.6/xfs_trace.h |  356 ++++++++++++++++++++++--------------------
>  1 files changed, 188 insertions(+), 168 deletions(-)
> 


