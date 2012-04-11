Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949Ab2DKTUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:20:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61186 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2DKTUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:20:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F85C6D5.6080904@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
 <4F85C6D5.6080904@zytor.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 15:20:10 -0400
Message-ID: <CAHGf_=ro=TwrYw4UoUMaHjb08rVbz-KjovZfND608J26w=n4HQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 2:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/10/2012 05:09 PM, KOSAKI Motohiro wrote:
>>
>> I know the reason. fcntl(F_NEXT) is one of a proposal of next SUS enhancement.
>>
>>   http://austingroupbugs.net/view.php?id=149
>>
>> nextfd() has a semantics of F_NEXT.
>>
>
> Looking at that bug report, it sounds like that proposal was rejected.

?

If I understand correctly, above URL says, latest satatus is

  Resolution: Accepted As Marked

Please see toppest issue summary. Or if I am missing something, can you please
point out which line are you seeing?
