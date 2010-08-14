Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0HNICS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:02:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab0HNICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=FtLnus+XQLZESg8r9+r8BNBmtopx3ShlbLw5zw+BxM5N4ye0i0VnNI2F7to3I4RoHA
         2vkNMlxpQyid3YF8PKe4noUFR3FH26KjYQ5AmzE0OQcsPFstLpId7ECKJIbznHxc9v//
         YG8HTrgIDQUjXfX5ejHbd1FPbYJyX8HbnEyHI=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Date: Sat, 14 Aug 2010 17:34:55 +1000
Organization: scattered
Message-ID: <h6hc66dkok3im9jpph1oj2m40ijju6c9la@4ax.com>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com> <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com> <AANLkTimruyaAB-raY2ywqPQSR-h+yp7tME=eTKngcMQm@mail.gmail.com> <20100814004729.GA3695@suse.de>
In-Reply-To: <20100814004729.GA3695@suse.de>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 17:47:29 -0700, you wrote:

>On Fri, Aug 13, 2010 at 05:12:57PM -0700, Linus Torvalds wrote:
>> On Fri, Aug 13, 2010 at 4:47 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
>> >
>> > Machine is running, but there's a lot of these in the dmesg:
>> >
>> > WARNING: at include/linux/security.h:1826 acct_stack_growth+0xe7/0xf0()
>> 
>> That would seem to be because of the lack of commit 05fa199d45c in
>> 2.6.27. It got marked for stable, but probably never went so far back
>> as 2.6.27.
>
>Yup, I didn't include it there.  Grant, if you add that, does the
>warning go away?

I'm sorry, no idea at all how to cherry pick that, I don't know git :( 

Google brings up this thread but not that commit, point me at it and 
I'll try it.  

Grant.

>
>> That said, I do wonder if it is worth it maintaining a 2.6.27 that the
>> maintainer can't even boot on his machines any more.
>
>Yeah, I'm beginning to wonder about it as well.  I think it's expected
>lifespan is very near to the end.
>
>thanks,
>
>greg k-h
