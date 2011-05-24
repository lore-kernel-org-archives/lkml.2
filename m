Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1EXRLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:11:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50246 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1EXRLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CEGxcCGSE3pu+FCYpRyTwKR08j2KhOku4Y5nIhj1+7Bh4zvvlzAAq5AkxIfIaq6XfI
         dEvhAOL7KOK1ZYSzATJMogKHgPe6pCel0SsOxp/rbExam2IoMRIxPgKYFPrhvWgYxmvT
         vocNoBjZMyUYlY4YD/sMQXRJNjaFoCQHdIZL0=
MIME-Version: 1.0
In-Reply-To: <BANLkTim-zRShhy49d7yn5WTJYzR6A2DtZQ@mail.gmail.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au> <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
 <BANLkTine2kobQA8TkmtiuXdKL=07NCo2vA@mail.gmail.com> <BANLkTim-zRShhy49d7yn5WTJYzR6A2DtZQ@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 24 May 2011 13:10:42 -0400
Message-ID: <BANLkTi=U8ikZo65AoxGznCopGMTFOUXWhQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, "Balbi, Felipe" <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 00:10, Mike Frysinger wrote:
> On Tue, May 24, 2011 at 00:01, Linus Torvalds wrote:
>> On Mon, May 23, 2011 at 7:06 PM, Mike Frysinger wrote:
>>>
>>> more failures:
>>
>> Is this blackfin or something?
>
> let's go with "something" ...
>
>> I did an allyesconfig with a special x86 patch that should have caught
>> everything that didn't have the proper prefetch.h include, but non-x86
>> drivers would have passed that.
>
> the isp1362-hcd failure probably is before your
> 268bb0ce3e87872cb9290c322b0d35bce230d88f.  i think i was reading a log
> that is a few days old (ive been traveling and am playing catch up
> atm).  i'll refresh and see what's what still.
>
> the common musb code only allows it to be built if the arch glue is
> available, and there is no x86 glue.  so an allyesconfig on x86
> wouldnt have picked up the failure.  it'll bomb though for any target
> which does have the glue.

latest tree seems to only fail for me now on the musb driver.  i can
send out a patch later today if no one else has gotten to it yet.
-mike
