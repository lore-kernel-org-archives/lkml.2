Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1AJW4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:56:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1AJW4c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1101110855330.28785@tundra.namei.org>
References: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org>
 <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com> <alpine.LRH.2.00.1101110855330.28785@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 14:55:41 -0800
Message-ID: <AANLkTik1kxC_GBKYSvhAK6_O0Bt-ALbEP3T=+AmMQRLP@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 2.6.38
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 1:56 PM, James Morris <jmorris@namei.org> wrote:
>
> In these cases it's my local 'master', which is tracking your tree.  I'll
> look at renaming that or creating a new branch called linus-master.

That doesn't much help. It now says the source, but still gives no
indication _why_ you pulled.

If you want to sync up, use a tag or something. Then it actually makes
sense, and a merge message like "Merge tag 'v2.6.36-rc7'" actually
makes sense.

But "Merge branch 'linus-master'" just makes me (and anybody else) go
"why did the security tree merge some random daily thing"?

                 Linus
