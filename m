Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2FUGua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:50:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40703 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2FUGu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:50:27 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <4FE2A825.1060103@landley.net>
References: <1340095897-9014-1-git-send-email-wenqing.lz@taobao.com>
	<CAG27Bk2tXprRfMfYOVdWtwSbjw5Rw9Kxs6Wns+Gm65m3hoJawg@mail.gmail.com>
	<20120619102706.GA9273@gmail.com>
	<4FE2A825.1060103@landley.net>
Date: Thu, 21 Jun 2012 08:50:25 +0200
X-Google-Sender-Auth: YWQRTM0Qigs04L4so5ovG8yewgw
Message-ID: <CAG27Bk1_q+fBvG49TO1TjwwALVjwhNoEWTOaiiUJt65=-3+7Kg@mail.gmail.com>
Subject: Re: [PATCH] docs: block: update ioprio.txt
From: Sami Kerola <kerolasa@iki.fi>
To: Rob Landley <rob@landley.net>
Cc: Jens Axboe <axboe@kernel.dk>, Bernhard Voelker <mail@bernhard-voelker.de>,
        Zheng Liu <wenqing.lz@taobao.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 6:50 AM, Rob Landley <rob@landley.net> wrote:
> On 06/19/2012 05:27 AM, Zheng Liu wrote:
>> Hi Sami,
>>
>> [You forgot to CC'd other developers and mailing list]

Some times I do that intentionally. Oh, well now when my opinion is public...

>> On Tue, Jun 19, 2012 at 10:54:41AM +0200, Sami Kerola wrote:
>>> Hi Zheng,
>>>
>>> Wouldn't a patch such as below be better?
>>
>> Looks good to me.  But, IMHO, if reader cannot access Internet, my patch
>> maybe is better for them.  The original writer is not me.  So I don't
>> understand the original idea that puts ionice source code in here.  I
>> think that Jens can do the final decision.
>>
>> Hi Jens,
>>
>> What's your opintion about Sami's and my patch?
>
> I note that it's nice to have a reference implementation for nontrivial
> things. Also, util-linux isn't the end-all and be-all of linux
> userspace: busybox has an ionice, and I plan to add an ionice
> implementation to toybox as well.
>
> So fixing reference code is good. That said, this isn't a "fix", this is
> a rewrite adding all sorts of unnecessary complexity
> (internationalization? strtos32_or_error() instead of strtol()?) that
> makes it much _less_ effective as reference code.

That makes sense. How about having simple example in linux
Documentation/ and note with reference link to util-linux
implementation. The note could tell something like 'version various
distributions package comes from util-linux, please see [git link]'.

-- 
   Sami Kerola
   http://www.iki.fi/kerolasa/
