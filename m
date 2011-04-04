Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1DDVqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:46:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab1DDVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110404210639.GA6133@sucs.org>
References: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com>
 <20110404194230.GA8785@sucs.org> <BANLkTik_MNB+4vWXw2k0-B-2B1_4MO3HMg@mail.gmail.com>
 <BANLkTi=oZ8a8EwbraRm4n-wjmyrLe+MySg@mail.gmail.com> <20110404210639.GA6133@sucs.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Apr 2011 14:39:29 -0700
Message-ID: <BANLkTinim5hdXJpMYG-naCt9-G4jKL52Hg@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.39-rc1: f23eb2b breaks console output
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 2:06 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Tue, Apr 05, 2011 at 12:42:54AM +0400, Alexander Beregalov wrote:
>> On 4 April 2011 23:59, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >
>> > Does this patch make a difference?
>> Yes, it works on top of 2.6.39-rc1-00184-g78fca1b9
>
> This fixes the problem for me too (on top of
> 148086bb64694cc91624bab2a550d50f800eb4b7 ).

I had that patch pending because Dave Jones had reported a less
extreme case of this earlier, but I never got a definitive ack from
him on it.

But with you two confirming it, it's now committed as commit
a5660b41af6a ("tty: fix endless work loop when the buffer fills up")
in my tree.

Thanks,

                             Linus
