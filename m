Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0FNWwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:52:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab0FNWwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:52:51 -0400
Date: Mon, 14 Jun 2010 15:51:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH v2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
Message-Id: <20100614155157.dca38e09.akpm@linux-foundation.org>
In-Reply-To: <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
References: <1276283791.8557.29.camel@maxim-laptop>
	<1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 22:19:55 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
> in pm notified while userspace is still running.
> Thus it will be possible to sync it propely.

That paragraph is a disaster and I'm not sure that I understand it well
enough to repair it.  I think you wanted s/now/not/ and s/in/if/ and
s/it will be/it will not be/.  Or perhaps you didn't.

Please send a comprehensible replacement.

