Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1KUXdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:33:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab1KUXdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:33:11 -0500
Date: Mon, 21 Nov 2011 15:33:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Li Shaohua <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] readahead: basic support for backwards prefetching
Message-Id: <20111121153309.d2a410fb.akpm@linux-foundation.org>
In-Reply-To: <20111121093846.887841399@intel.com>
References: <20111121091819.394895091@intel.com>
	<20111121093846.887841399@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:18:26 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Add the backwards prefetching feature. It's pretty simple if we don't
> support async prefetching and interleaved reads.

Well OK, but I wonder how many applications out there read files in
reverse order.  Is it common enough to bother special-casing in the
kernel like this?


