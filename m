Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2GRWvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:51:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2GRWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:51:42 -0400
Date: Wed, 18 Jul 2012 15:51:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Allow CLOCK_TICK_RATE to be undefined
Message-Id: <20120718155141.232ae14c.akpm@linux-foundation.org>
In-Reply-To: <1342543300-23460-1-git-send-email-catalin.marinas@arm.com>
References: <1342543300-23460-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 17:41:40 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch allows an architecture to not define CLOCK_TICK_RATE, in
> which case ACTHZ defaults to (HZ << 8).

No reason was given for this change.

So those people who are wondering "why don't you just define
CLOCK_TICK_RATE" are made all sad.

