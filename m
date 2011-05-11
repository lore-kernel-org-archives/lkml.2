Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1EKQDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:03:55 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:61676 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1EKQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ukC0yMKfkX4syCiaO7qT7GdG6uWpyY7Ez2tzSuCN89bZgkzjRRHH8X15/vxLSwVYT7
         MrZH3RbVFswM3eYjctJk+gEczn1Xrd2DZCKeKzrZ0FYkhH39ZMaWRDTPMaCOp3prf/kT
         eUCHn0u8LddHiCxhSQNOOdPp8N52juA4ZrIhQ=
Subject: Re: [PATCH] blk-throttle: fix typos on struct throtl_grp init code
From: Namhyung Kim <namhyung@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20110511133033.GD31633@redhat.com>
References: <20110511130732.GB31633@redhat.com>
	 <1305120045-5111-1-git-send-email-namhyung@gmail.com>
	 <20110511133033.GD31633@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 23:14:02 +0900
Message-ID: <1305123242.1561.20.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-11 (수), 09:30 -0400, Vivek Goyal:
> On Wed, May 11, 2011 at 10:20:45PM +0900, Namhyung Kim wrote:
> > s/td/tg/
> 
> I think jens would like to have little more changelog than that.
> 

OK, let me clarify this first: My first patch was trivial but second one
seems not. AFAICS it could affect when the bps/iops bandwidth change
applies - maybe delayed to next @tg->disptime? - if there are concurrent
cgroup init and limit change tasks, right? Or do you have something need
to be included in the changelog?


> Otherwise looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Vivek

Thank you for the review and the comment.


-- 
Regards,
Namhyung Kim


