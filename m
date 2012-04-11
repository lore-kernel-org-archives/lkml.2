Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2DKSBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:01:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59405 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab2DKSBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:01:01 -0400
Message-ID: <4F85C6D5.6080904@zytor.com>
Date: Wed, 11 Apr 2012 11:00:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
In-Reply-To: <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 05:09 PM, KOSAKI Motohiro wrote:
> 
> I know the reason. fcntl(F_NEXT) is one of a proposal of next SUS enhancement.
> 
>   http://austingroupbugs.net/view.php?id=149
> 
> nextfd() has a semantics of F_NEXT.
> 

Looking at that bug report, it sounds like that proposal was rejected.

	-hpa

