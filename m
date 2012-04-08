Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2DHOyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 10:54:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2DHOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 10:54:37 -0400
Date: Sun, 8 Apr 2012 09:54:27 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REVIEW][PATCH 0/43] Completing the user namespace
Message-ID: <20120408145427.GA20790@sergelap>
References: <m11unyn70b.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Eric.

While this approach has limitations and administrative overhead which I'd
prefer it didn't, it also has huge benefits, especially faster id comparisons
and, most importantly, type safety enforcing that the right kinds of uids
are compared.

So I endorse this approach.

I've reviewed and acked many of the patches, some I still had questions on,
but the approach as a whole gets an ack from me.

thanks,
-serge
