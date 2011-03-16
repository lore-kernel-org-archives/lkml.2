Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1CPUaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:30:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978Ab1CPUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110316202117.GW22723@ZenIV.linux.org.uk>
References: <20110316144253.GT22723@ZenIV.linux.org.uk> <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
 <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com>
 <E1PzvHb-0006x5-IF@pomaz-ex.szeredi.hu> <AANLkTikTRntUNBHnBrOdcCbRfmo=mNiYMDkeV61qhA17@mail.gmail.com>
 <20110316202117.GW22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 13:29:38 -0700
Message-ID: <AANLkTimy56PyewrdUm+gDoET99_nJ24h3W0ijhMn-3Ad@mail.gmail.com>
Subject: Re: [git pull] several fixes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 1:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> In tree, with edited commit message...

Well, not edited enough. It still talks about "not needing".

That thing "doesn't need" a cdev_put() the same way I "don't need" to
be shot in the head.

But whatever.  Pulled.

                 Linus
