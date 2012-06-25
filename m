Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2FYCP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 22:15:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2FYCP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 22:15:26 -0400
Message-ID: <4FE7C9B8.7060506@gmail.com>
Date: Mon, 25 Jun 2012 10:15:20 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Doug Smythies <dsmythies@telus.net>,
        "'Yong Zhang'" <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?B?J+WQq+m7myc=?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com> 		 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com> 		 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com> 		 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy> 	 <1340097532.21745.19.camel@twins> <000001cd4e33$496f6c30$dc4e4490$@net>  <1340185528.21745.86.camel@twins> <002301cd4f64$17a055c0$46e10140$@net> <1340373782.18025.74.camel@twins>
In-Reply-To: <1340373782.18025.74.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 22, 2012 10:03 PM, Peter Zijlstra wrote:

> Doug, Charles,
> 
> Can you both confirm that the below patch is what you tested and we
> should finally be able to close this issue?
> 
> 
> ---

[... patch code deleted ...]

Yes, this patch can cure my problem.
