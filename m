Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2EGFZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:25:39 -0400
Received: from ozlabs.org ([203.10.76.45]:51304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2EGFYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Cc: Alessio Igor Bogani <abogani@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] modpost: Stop grab_file() from leaking filedescriptors if fstat() fails
In-Reply-To: <alpine.LNX.2.00.1204222039010.27455@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204222039010.27455@swampdragon.chaosbits.net>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 13:20:35 +0930
Message-ID: <87ipg8fy44.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012 20:40:49 +0200 (CEST), Jesper Juhl <jj@chaosbits.net> wrote:
> In case the open() call succeeds but the subsequent fstat() call
> fails, then we'll return without close()'ing the filedescriptor.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.

Thanks,
Rusty.
