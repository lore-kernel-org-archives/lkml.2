Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2IQTpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:45:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52692 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab2IQTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:45:01 -0400
Message-ID: <50577DB7.7070008@kernel.dk>
Date: Mon, 17 Sep 2012 21:44:55 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Where can find block layer lockless queue work.
References: <CAFR8uecAmdWcXf=dYgXsBzeik_137YZqiQ=FY7Ph=cvaQ+AXrQ@mail.gmail.com>
In-Reply-To: <CAFR8uecAmdWcXf=dYgXsBzeik_137YZqiQ=FY7Ph=cvaQ+AXrQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-17 20:52, Muthu Kumar wrote:
> Hi All,
> I heard there is some work going on to support lockless queue in the
> block layer. Is there a git repo with current changes that I can
> follow? Any info on this work is appreciated. Thanks a lot.

It's in my new-queue branch of the block git repo:

http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/new-queue

Most work so far has been to get it into a quick state where an intern
here could show changes in scaling. There's lots more pending. It'll
be revised shortly.

-- 
Jens Axboe

