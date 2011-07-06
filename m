Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1GFRgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:36:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34005 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1GFRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:36:37 -0400
Date: Wed, 6 Jul 2011 21:36:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        kernel-hardening@lists.openwall.com
Subject: Re: RLIMIT_NPROC check in set_user()
Message-ID: <20110706173631.GA5431@albatros>
References: <20110612130953.GA3709@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612130953.GA3709@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 17:09 +0400, Vasiliy Kulikov wrote:
> I'd be happy to hear opinions about improving the fixes above or
> alternative fixes.

No comments?  Even "Sigh, what a nasty problem.  But we cannot really
fix it without significantly breaking the stuff.  Go and drink something." ?

-- 
Vasiliy
