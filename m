Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1HZBE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 21:04:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab1HZBE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:04:57 -0400
Date: Thu, 25 Aug 2011 18:07:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Neaten warn_alloc_failed
Message-Id: <20110825180734.9beae279.akpm@linux-foundation.org>
In-Reply-To: <1314319088.19476.17.camel@Joe-Laptop>
References: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
	<20110825165006.af771ef7.akpm@linux-foundation.org>
	<1314316801.19476.6.camel@Joe-Laptop>
	<20110825170534.0d425c75.akpm@linux-foundation.org>
	<1314319088.19476.17.camel@Joe-Laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 17:38:08 -0700 Joe Perches <joe@perches.com> wrote:

> So if you really like it that much:

Well I don't particularly like it, personally.  But they're there, so
we either fully use them or fully unuse them, then remove them.
