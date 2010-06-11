Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535Ab0FKTns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:43:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554Ab0FKTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <20100611193731.GA3018@think>
References: <20100611193731.GA3018@think>
Date: Fri, 11 Jun 2010 12:43:10 -0700
Message-ID: <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
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

On Fri, Jun 11, 2010 at 12:37 PM, Chris Mason <chris.mason@oracle.com> wrote:
>
> The master branch of the btrfs-unstable tree is a collection of fixes
> and cleanups, including two btrfs regressions from rc1:

Ok, no pulling then. See all the millions of threads how I wanted only
critical fixes for -rc3 since I'll be offline.

You have a couple of hours for a minimal fix pull request with just
the regression fixes if you want to hit -rc3. Then I'll cut a release
and be gone for a while.

                      Linus
