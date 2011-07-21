Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1GUVhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:37:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab1GUVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:37:42 -0400
Date: Thu, 21 Jul 2011 14:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] notifier error injection
Message-Id: <20110721143709.0c1e66d6.akpm@linux-foundation.org>
In-Reply-To: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
References: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 10:16:01 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This provides the ability to inject artifical errors to the following
> notifier chain callbacks. It is useful to test the error handling of
> notifier call chain failures.

That all looks very nice, but I wonder how many people are actually
using these things.  The injection framework itself doesn't seem to
have had a lot of uptake.

I wonder if we could improve things by adding an easy-to-run testing
script which identifies all the available error-injection inputs,
exercises them and then reports on the result?

Such a script would logically reside under ./tests/fault-injection/,
but we still don't have a tests/ directory.  Which perhaps tells us
something ;)

