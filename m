Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1LLR1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:27:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36766 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1LLR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:27:33 -0500
Date: Mon, 12 Dec 2011 09:27:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, cgroups@vger.kernel.org,
        bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
Message-ID: <20111212172725.GA25802@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-3-git-send-email-glommer@parallels.com>
 <4EE4FCBB.9050600@gmail.com>
 <4EE51646.3030900@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE51646.3030900@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Dec 11, 2011 at 09:44:54PM +0100, Glauber Costa wrote:
> On 12/11/2011 07:55 PM, KOSAKI Motohiro wrote:
> > Can you please tell us which compiler failed automatic inlining?
> > I suspect gcc is enough sane and we don't need this patch.
> 
> Of course we don't need, that's the very definition of a "nitpick".
> This patch is directed towards the reader, not the compiler. Maintainers
> are free to take it or not, although I believe being explicit is better.

These days, I don't think adding inline buys us much (other than
explicit cases where always_inline or noinline is necessary).  gcc
already does good enough job for inlining and 'inline' hint seems more
to hinder rather than help and I don't really see what it buys for
code readers either, so I won't be taking this one.

Thanks.

-- 
tejun
