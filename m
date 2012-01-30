Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2A3Fvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:51:48 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46493 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2A3Fvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:51:47 -0500
X-AuditID: 9c93016f-b7c20ae000005067-8c-4f262ff18bd9
Message-ID: <4F262FEF.9020406@gmail.com>
Date: Mon, 30 Jan 2012 14:51:43 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.device-mapper.devel
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org> <4F25F5F3.6060507@gmail.com> <20120130014703.GG17211@htj.dyndns.org> <4F25FEE5.5010309@gmail.com> <20120130023012.GH17211@htj.dyndns.org> <4F260547.1030405@gmail.com> <20120130025326.GI17211@htj.dyndns.org>
In-Reply-To: <20120130025326.GI17211@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-30 11:53 AM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jan 30, 2012 at 11:49:43 AM +0900, Namhyung Kim wrote:
>> Yes, blktrace will see both of completions for rq and bio's it
>> contains from now on, and I thought it's your intention? For the
>> bounced bio's, it'll see one more completion per bio.
>
> Umm... no, blktrace users shouldn't see confusing outputs.  My point
> was that we should leave raw tracepoints as raw monitor points so that
> they can provide raw data to different users and filter from
> blktrace.c so that the existing users aren't disturbed.
>

That means blktrace should not be changed, and not see duplicated 
completions for rq based drivers at all?

Thanks,
Namhyung
