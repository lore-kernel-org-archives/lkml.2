Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1AKWor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:44:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab1AKWop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:44:45 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikB4XJRQ-NVW3BJpVSyTJi57DuAvog9frefGfGX@mail.gmail.com>
References: <20110111205233.GC4501@quack.suse.cz> <AANLkTikB4XJRQ-NVW3BJpVSyTJi57DuAvog9frefGfGX@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 14:44:23 -0800
Message-ID: <AANLkTimsTvMi3t2c5CfCBY32rnF5NxwMwYGOYw7J77AX@mail.gmail.com>
Subject: Re: [PULL REQUEST] UDF tree
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm.. The Kconfig file still claims it depends on BKL, so you cannot
> actually build it without that.
>
> Oversight? Or is it not complete?

Seems to be an oversight, because it compiles without the BKL.

I'll remove that thing in the merge commit, evil as I am.

                     Linus
