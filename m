Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2HQP2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:28:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab2HQP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:28:29 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PUxD9mNbTSIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=PkYMVV_Y2y8A:10 a=meVymXHHAAAA:8 a=9lC4D9FEF-Lmuyl_eyIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345217308.3708.35.camel@gandalf.local.home>
Subject: Re: [RFC PATCH v2] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Steven Rostedt <rostedt@goodmis.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tim.bird@am.sony.com,
        lizefan@huawei.com
Date: Fri, 17 Aug 2012 11:28:28 -0400
In-Reply-To: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
References: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 09:03 -0300, Ezequiel Garcia wrote:
> This patch splits trace event initialization in two stages:
>  * ftrace enable
>  * sysfs event entry creation
> 
> This allows to capture trace events from an earlier point
> by using 'trace_event' kernel parameter and is important
> to trace boot-up allocations.
> 

This is much better, I'll give it some tests and add it to my 3.7 queue.

Thanks,

-- Steve


