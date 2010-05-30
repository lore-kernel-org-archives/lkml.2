Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0E3Aj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 20:39:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab0E3AjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 20:39:24 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=2iQPwODrlvMA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=siATOLSJuON90bMvc2sA:9 a=VUkxu63Sq8aEJLU4XyQA:7 a=nAEgpHB0WXwWgUiqnjpT5Oc3xnYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of 
 do_splice_direct()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Changli Gao <xiaosuo@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, axboe@kernel.dk,
       Al Viro <viro@zeniv.linux.org.uk>, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <AANLkTim6tj4OKnLGW2dDIsvAmeU6b9Qsi6IZKdvlKHV2@mail.gmail.com>
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com>
	 <E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu>
	 <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com>
	 <AANLkTimCXzrXcfwbCy5MZ3D40WBnGbF6Kbj6egTSjk2s@mail.gmail.com>
	 <1275150019.22648.615.camel@gandalf.stny.rr.com>
	 <AANLkTim6tj4OKnLGW2dDIsvAmeU6b9Qsi6IZKdvlKHV2@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 29 May 2010 20:39:20 -0400
Message-ID: <1275179960.4825.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-30 at 07:58 +0800, Changli Gao wrote:
> On Sun, May 30, 2010 at 12:20 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > [ Removed matthew@wil.cx since I'm getting errors in sending to that address ]
> >

> But why not use (file->f_flags & O_NONBLOCK) instead, as
> tracing_splice_read_pipe() does?

Probably because I copied the code from something that used
SPLICE_F_NONBLOCK ;-)

But userspace passes that flag too. Although, maybe I just don't
understand the API fully.

-- Steve



