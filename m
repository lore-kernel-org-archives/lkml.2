Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1CTHDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 03:03:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48218 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1CTHC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 03:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=muQBDMPHM8oK1/buiBgTo39H2dupNjrgQg7YHS6lhF0MDm0hij3nfmvszFudkestOK
         4BRt+qUxTEk2cmXIm33zSZiSdsR2TwxSVRvA8EGvKxy98l414Np3ZfbGRlQ7ckyJe2hh
         pPf4NMQnPnVQelhNJBS59ZbuLMUwGp38k1MQk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
	<AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
Date: Sun, 20 Mar 2011 09:02:58 +0200
X-Google-Sender-Auth: z-xCmbAgjGTtB78wGHpHhSYinCQ
Message-ID: <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Pekka Enberg <penberg@kernel.org>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 18, 2011 at 11:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> But if we can teach checkpatch to read the rule files, then maybe that
>> would be beneficial.

On Sun, Mar 20, 2011 at 5:40 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> The problem is Perl doesn't really understand C, while Coccinelle does.

It would be nice if Coccinelle would be even more easy to setup and
use during development. Like with Dave, Coccinelle has been on my todo
list forever.
