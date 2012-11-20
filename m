Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2KTFwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:52:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2KTFwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:52:18 -0500
Date: Mon, 19 Nov 2012 21:52:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 3/3] man-pages: Add man page for vmpressure_fd(2)
Message-Id: <20121119215211.6370ac3b.akpm@linux-foundation.org>
In-Reply-To: <20121107110152.GC30462@lizard>
References: <20121107105348.GA25549@lizard>
	<20121107110152.GC30462@lizard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012 03:01:52 -0800 Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

>        Upon  these  notifications,  userland programs can cooperate with
>        the kernel, achieving better system's memory management.

Well I read through the whole thread and afaict the above is the only
attempt to describe why this patchset exists!

How about we step away from implementation details for a while and
discuss observed problems, use-cases, requirements and such?  What are
we actually trying to achieve here?
