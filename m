Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1DYXwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:52:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab1DYXwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ro4rtZGYgLB+Epg66Ex6OgLjfW6fS9JN70z7ru9ZiPu3gkgh40R7TAzmqThaqXPvFU
         kXZlr3oo1Bfv6uvqiOAA==
MIME-Version: 1.0
In-Reply-To: <1303745985.18763.14.camel@gandalf.stny.rr.com>
References: <1303513209-26436-1-git-send-email-vnagarnaik@google.com>
 <20110425113723.2666.A69D9226@jp.fujitsu.com> <1303745985.18763.14.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 25 Apr 2011 16:52:05 -0700
Message-ID: <BANLkTimochpX5Tzvj0Yz6Lb+3-tcFuZXqQ@mail.gmail.com>
Subject: Re: [PATCH] trace: Add tracepoints to fs subsystem
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 8:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-04-25 at 11:35 +0900, KOSAKI Motohiro wrote:
>> > From: Jiaying Zhang <jiayingz@google.com>
>> >
>> > Many fs tracepoints can now be traced via ftrace, however there are a
>> > few other tracepoints needed. This patch adds entry and exit tracepoints
>> > for a few additional functions, viz.:
>> > wait_on_buffer
>> > block_write_full_page
>> > mpage_readpages
>> > file_read
>>
>> Zero background description?
>>
>
> Good point.
>
> Could you please describe how this is useful, and how one can benefit
> from these tracepoints.
>
I am sending a new patch with a better description and using the template for
declaring events.

> -- Steve
>
>
>
>

Thanks
Vaibhav Nagarnaik
