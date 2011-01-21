Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1AUGSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:18:50 -0500
Received: from lo.gmane.org ([80.91.229.12]:35605 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1AUGSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:18:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Do not potentially overflow string in sumversion
Date: Fri, 21 Jan 2011 06:18:35 +0000 (UTC)
Message-ID: <ihb8fr$jbj$1@dough.gmane.org>
References: <alpine.LNX.2.00.1101202353010.11854@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 123.125.1.164
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 00:00:56 +0100, Jesper Juhl wrote:

> In scripts/mod/sumversion.c (in get_src_version()) we call
> getenv("MODVERDIR"). This returns a pointer to a string of unknown
> length. This string of unknown length we then pass on as an argument to
> sprintf() and tell it to write the result to 'filelist' which has a,
> very much fixed, size of 'PATH_MAX + 1'. If the string returned by
> getenv() is too long we'll overrun the statically allocated buffer. This
> patch prevents the buffer overrun by using snprintf() and telling it to
> copy a maximum of 'PATH_MAX + 1' bytes (including the terminating \0).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net> ---

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Next time, please Cc linux-kbuild for kbuild changes.

Regards.


