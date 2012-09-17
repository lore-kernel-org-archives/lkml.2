Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2IQRzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:55:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54219 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab2IQRzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:55:50 -0400
Date: Mon, 17 Sep 2012 10:55:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jianpeng Ma <majianpeng@gmail.com>, fweisbec <fweisbec@gmail.com>,
        mingo <mingo@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Tao Ma <boyu.mt@taobao.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Why blktrace didn't trace requests merge?
Message-ID: <20120917175534.GG18677@google.com>
References: <201209171933464847623@gmail.com>
 <1347888148.13080.20.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347888148.13080.20.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)

On Mon, Sep 17, 2012 at 09:22:28AM -0400, Steven Rostedt wrote:
> On Mon, 2012-09-17 at 19:33 +0800, Jianpeng Ma wrote:
> > Hi all:
> > 	I used blktrace to trace some io.But i can't find requests merge. I searched the code and did't not find.
> > 	Why? 
> > 									
> 
> No idea. I don't use blktrace much, but I Cc'd those that understand it
> better than I.

-- 
tejun
