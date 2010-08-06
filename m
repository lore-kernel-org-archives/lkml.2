Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519Ab0HFPwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:52:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab0HFPv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 08:51:36 -0700
Message-ID: <AANLkTi=WyWdERdyM+X5VOTX02_O_5GqV9hBQ145RmMWg@mail.gmail.com>
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>                                                                    ... And
> once you _do_ ask me to merge from you, I still don't want you to do
> the merge, because I want to know about what conflicts. That's where
> the bugs almost always are.

Actually, let me rephrase that.

Almost all bugs are just individual commits. But the "oh, we had
conflicts between trees" is where the subtle bugs that are due to
interactions between two different development projects tend to be..

So "almost always" is not really true - almost always bugs are just
simply bugs: incorrect code. I wish we didn't have that, but hey,
reality clearly hates me.  But the reason I want to see the merge
problems (even if I then occasionally end up having to send it back
and say "ok, I see the merge problem and I can't handle it, you do it
for me") is because that way I _see_ when people step on each others
feet. Because when it happens, it's ripe for nasty issues, including
simply ones that are due to bad development habits, or due to bad
source tree organization.

                          Linus
