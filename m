Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1DZTVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:21:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36102 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1DZTVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uY3nn+yOMqGHM8efJkr8FWn+RXErbu1UlHiJhaBq/7xtA4fat/8JksmkZVyUCK/1CP
         uh3WuoXdhjt7xbUPgl0qFv0yCV+ADgLA5GNS32fitA4B1PZg2y/MSqGLkqKNL/d+rbfJ
         3w3vyQu0BVhlnLIi/wqNoiHgNEjPOsXwVGB6U=
MIME-Version: 1.0
In-Reply-To: <20110426192029.GA4686@p183>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110426190531.GA4556@p183>
	<1303845468.18763.32.camel@gandalf.stny.rr.com>
	<20110426192029.GA4686@p183>
Date: Tue, 26 Apr 2011 16:21:43 -0300
Message-ID: <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 4:20 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
>> On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
>> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
>
>> > >  /**
>> > > + * streq - Are two strings equal?
>> > > + * @a: first string
>> > > + * @b: second string
>> > > + *
>> > > + * Example:
>> > > + *       if (streq(argv[1], "--help"))
>> > > + *               printf("%s\n", "This help");
>>
>> Userspace example?
>
> The point is that function is trivial, and if someone doesn't
> understand it, he should read some Kernighan and Ritchie first.
>

I'm fine to remove (should I Steven?). I don't care about the example.
People reading the code here knows what is this for.
