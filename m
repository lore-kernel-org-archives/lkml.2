Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1AKWkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:40:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112Ab1AKWkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <20110111205233.GC4501@quack.suse.cz>
References: <20110111205233.GC4501@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 14:39:39 -0800
Message-ID: <AANLkTikB4XJRQ-NVW3BJpVSyTJi57DuAvog9frefGfGX@mail.gmail.com>
Subject: Re: [PULL REQUEST] UDF tree
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:52 PM, Jan Kara <jack@suse.cz> wrote:
>
> The largest portion of patches is BKL removal from UDF.

Hmm.. The Kconfig file still claims it depends on BKL, so you cannot
actually build it without that.

Oversight? Or is it not complete?

                     Linus
