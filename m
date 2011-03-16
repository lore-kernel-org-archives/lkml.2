Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1CPSuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:50:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab1CPSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <E1PzvHb-0006x5-IF@pomaz-ex.szeredi.hu>
References: <20110316144253.GT22723@ZenIV.linux.org.uk> <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
 <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com> <E1PzvHb-0006x5-IF@pomaz-ex.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 11:49:31 -0700
Message-ID: <AANLkTikTRntUNBHnBrOdcCbRfmo=mNiYMDkeV61qhA17@mail.gmail.com>
Subject: Re: [git pull] several fixes
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 11:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> "doesn't need" or "must not have"?
>
> It must not have one, otherwise refcounting will go astray.

That's what I thought. The commit message just seemed to be off.

> That cdev_put() should really be moved into f_op->release(), but that
> would be quite a bit of work.

Yeah. Al?

                      Linus
