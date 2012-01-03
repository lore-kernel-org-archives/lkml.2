Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2ACQUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:20:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54129 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2ACQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:20:42 -0500
MIME-Version: 1.0
In-Reply-To: <010601ccc9ef$7e784640$7b68d2c0$%kim@samsung.com>
References: <20120103180854.e9bff732db50c0fa9afd2967@canb.auug.org.au> <010601ccc9ef$7e784640$7b68d2c0$%kim@samsung.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 08:20:20 -0800
X-Google-Sender-Auth: trj7mL6avrSywCAweUbvzGOIcmg
Message-ID: <CA+55aFzuEP7poPj_TiC28+T7Xn-6G1Lydt=q5FMVTj_XhOVf3w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the s5p tree
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 12:12 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> OK, I see. Firstly, I will rebase my for-next as per your suggestion. As you
> know, I just wanted to avoid known conflicts with driver-core tree.

Please, in general you should *not* rebase on top of other peoples
trees either. What's the conflict and why do you need that other tree
in the first place?

                       Linus
