Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2JOJn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:43:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab2JOJn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:43:58 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Nicolas Boullis <nboullis@debian.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: acm: fix the computation of the number of data bits
Date: Mon, 15 Oct 2012 11:42:10 +0200
Message-ID: <4771596.PL5eJBEN14@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20121013222923.GA1984@tryphon.debian.net>
References: <20121013222923.GA1984@tryphon.debian.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2012 00:29:24 Nicolas Boullis wrote:
> From: Nicolas Boullis <nboullis@debian.org>
> 
> The current code assumes that CSIZE is 0000060, which appears to be 
> wrong on some arches (such as powerpc).
> 
> Signed-off-by: Nicolas Boullis <nboullis@debian.org>

Acked-by: Oliver Neukum <oneukum@suse.de>

