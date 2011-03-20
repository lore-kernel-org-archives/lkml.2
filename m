Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1CTDko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 23:40:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44793 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1CTDkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 23:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OAq44L2JoJkJR2u33ApAz55ieSI1U41NbLQ4gaPRur15xM91GBrKBZxbWRtVWC3hVV
         +UzHZ50FruCMUMTWEPh+SnVuaeA2hlat7HuWUFtywUfyZcA1pQkh86j8awkzAJEfMU/t
         pUxzgJGq43YMACfYjFhF9A58W+mB27OeEz5uM=
MIME-Version: 1.0
In-Reply-To: <1300419170.16880.956.camel@gandalf.stny.rr.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
Date: Sun, 20 Mar 2011 11:40:41 +0800
Message-ID: <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But if we can teach checkpatch to read the rule files, then maybe that
> would be beneficial.
>

The problem is Perl doesn't really understand C, while Coccinelle does.
