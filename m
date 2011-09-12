Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1ILPGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:06:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab1ILPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:06:45 -0400
Date: Mon, 12 Sep 2011 19:06:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
Message-ID: <20110912150630.GE25367@sun>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110910164134.GA2442@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
> Historically /proc/slabinfo has 0444 permissions and is accessible to
> the world.  slabinfo contains rather private information related both to
> the kernel and userspace tasks.  Depending on the situation, it might
> reveal either private information per se or information useful to make
> another targeted attack.  Some examples of what can be learned by
> reading/watching for /proc/slabinfo entries:
> 
...

Since this file is controversy point, probably its permissions might be
configurable via setup option?

	Cyrill
