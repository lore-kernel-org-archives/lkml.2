Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0KKXoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:44:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39505 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0KKXoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:44:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o66L4kMAUNpGirsYN+tNb8LaTyAtOJW192qnHqUUSVUg/cQz918CyYAwvII1WjIErD
         uJjLIdBrzKZrOgv6u4qLyeZU4/ner9ZH/iKUDwS2Ur3xS0suAExvWPiQwcAu6D9qxMeL
         7ofEOp5rsQl7FqwSyJSScdRLAuE6o5n593QGI=
MIME-Version: 1.0
In-Reply-To: <1289515742.14141.0.camel@localhost.localdomain>
References: <4CDAF425.4050800@ccrma.stanford.edu>
	<alpine.LFD.2.00.1011102154330.2900@localhost6.localdomain6>
	<4CDC0429.8090506@gmail.com>
	<1289515742.14141.0.camel@localhost.localdomain>
Date: Thu, 11 Nov 2010 18:44:04 -0500
Message-ID: <AANLkTik6x=7jewJ-82yEH=6z9dSVevEbKWLtAqpSecEg@mail.gmail.com>
Subject: Re: 2.6.3x-rty where x > 3 and y >= 1?
From: Bernardo Barros <bernardobarros2@gmail.com>
To: Ng Oon-Ee <ngoonee@gmail.com>
Cc: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic4@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
        linux-kernel@vger.kernel.org,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        johnstul@us.ibm.com, rostedt@goodmis.org, npiggin@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to install the 2.6.36-bfs here, let's see what happens.. :-)

2010/11/11 Ng Oon-Ee <ngoonee@gmail.com>:
> On Thu, 2010-11-11 at 15:56 +0100, Niccolò Belli wrote:
>> Il 10/11/2010 21:54, Thomas Gleixner ha scritto:
>> > Working on it :)
>>
>> Glad to hear that, I can't use 2.6.33-rt anymore because of problems
>> with my intel video card and my band is starting to blame because of xruns.
>>
>> Darkbasic
>
> In the meantime, the -bfs kernel does improve the situation somewhat.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
