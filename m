Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0FKUAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:00:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145Ab0FKUAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100611194812.GD3018@think>
References: <20100611193731.GA3018@think>
	<AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
	<20100611194812.GD3018@think>
Date: Fri, 11 Jun 2010 13:00:02 -0700
Message-ID: <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:48 PM, Chris Mason <chris.mason@oracle.com> wrote:
>
> The others all fix oopsen or big problems, and I think fixing warnings
> helps avoid false negatives as others look for real problems?
>
> I'm happy to rebase out the 3 non-criticals.

There seems to be more than three non-criticals. There's the warning
fixes, the "unused variables" thing, the "memdup_user()" thing, a
couple of unnecessary NULL checks removed etc. On the whole, I do not
get the feeling that the pull request was actively trying to be
minimal, and that's what I really want to see.

                  Linus
