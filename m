Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1HJUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:51:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1HJUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:51:42 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=tm-GYG_pDuwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=D-QNkUr5niyDTvBi7rMA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 02/10] tracing/filter: Separate predicate init and
 filter addition
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1312452506-5100-3-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
	 <1312452506-5100-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 16:51:41 -0400
Message-ID: <1313009501.18583.270.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 12:08 +0200, Jiri Olsa wrote:
> Separating the filter_pred initialization from code
> that adds the filter_pred to the filter.
> 
> The create_pred returns initialized predicate, which
> is added to the filter by filter_add_pred function.
> 
> Keeping dry_run variable inside replace_preds function.

The only issue I have with this patch is the change log. It tells me
what you are doing, but does not tell us why you are doing it.

I'm pretty clueless about reviewing this patch, as I don't know what the
goal of the patch is. It's like a patch that says, increment i

+ i++;


-- Steve

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>


