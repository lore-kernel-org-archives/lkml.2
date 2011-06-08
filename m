Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1FHORV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:17:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57702 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab1FHORU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=RO+DXk2aCl0Gx0eiYhbH9b07Kxfjyp/Jli0moHWOo0zxOHb3wpjtMBwO6QO5ibyARN
         RHPhpjHMrDVZmenvq1nwzvIFfKQ8z9fBx26tUMqAqwhwCKVFRq0BHumqfmXDXRMw4Djk
         HwJSFiv+AC8Ik1+8zH1EO3xiAxcOvi64Uei+c=
MIME-Version: 1.0
In-Reply-To: <20110608133833.GD30037@thunk.org>
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
 <4DEE2C70.8060301@profihost.ag> <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
 <4DEE9EDA.90001@profihost.ag> <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
 <BANLkTim3GuppJ4=VHa0BgNV1d4nQjWUcbg@mail.gmail.com> <20110608133833.GD30037@thunk.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 8 Jun 2011 10:16:59 -0400
X-Google-Sender-Auth: xo8cPgKSQ3u6Wh1nIkJoWW4SxS0
Message-ID: <BANLkTimMhZWhUN3w_9Qapsqcic2_VCP0sg@mail.gmail.com>
Subject: Re: XFS problem in 2.6.32
To: "Ted Ts'o" <tytso@mit.edu>, John Kacur <jkacur@redhat.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

On Wed, Jun 8, 2011 at 9:38 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Jun 08, 2011 at 10:00:39AM +0200, John Kacur wrote:
>
>> Ok, I don't speak for my company, and your point about not expecting
>> people to do this work for you is valid, however I don't see why you
>> need to take potshots at Red Hat
>
> It wasn't a potshot; if it is true, it is a completely rational
> economic argument that is completely within the bounds of the
> requirements of the GPL, and with LKML community standards.
>
> The reason why I say it is because of (a) http://lwn.net/Articles/430098/,
> and (b) a few months ago, when I quietly floated starting a new
> long-term stable kernel series that a number of companies would
> maintain cooperatively, I was told, privately, that such a proposal
> would not likely be received positively by Red Hat management because
> of the reasons behind the policy instituted by (a).

OK, you seem to think you have it all figured out and that your Red
Hat contact knows everything there is to the Red Hat kernel
engineering development process.

However, it doesn't jive with what I know or how I (and my coworkers)
work on a daily basis.

Since we're referencing lwn.net articles please have a look at these
comments that I previously made on this subject of RHEL and stable@:
http://lwn.net/Articles/431317/
http://lwn.net/Articles/431420/

<snip irrelevant tangent about GPL>

>> I'm not even claiming that these are typical stats, but as just a
>> quick check on your statement, the contributions for one stable
>> release are in the same ballpark as everyone else.
>
> Nah, that just means that commits which are labelled with "CC:
> stable@vger.kernel.org" are automatically accepted into stable kernel
> series.
>
> If you can point efforts where painful backports of ext4 and xfs bug
> fixes into RHEL 6.x are making it back into 2.6.32.y, even though in
> some cases it takes tens of hours of engineering and QA efforts, we
> can talk.  But please note that I wasn't calling out Red Hat as being
> bad or evil by doing what they are doing; it is completely
> economically rational and allowed by the GPL rules for them to be
> doing what they are doing.  (Just as what Android has been doing with
> their constant forward porting of the Wakelocks API is completely
> within the GPL rules.)

And what _exactly_ is Red Hat (not) doing?  Red Hat isn't going crazy
backporting its upstream > 2.6.32 fixes to 2.6.32.y even when Red Hat
doesn't consume 2.6.32.y?  *gasp*

Mike
