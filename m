Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2IENeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:34:03 -0400
Received: from local.xorcom.com ([81.218.177.19]:48861 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2IENeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:34:01 -0400
Date: Wed, 5 Sep 2012 16:33:59 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH] Add mach-specific includes
Message-ID: <20120905133359.GL18204@xorcom.com>
References: <1344764843-2179-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040BFF3.6050705@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040BFF3.6050705@suse.cz>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 03:45:23PM +0200, Michal Marek wrote:
> 
> On 12.8.2012 11:47, Tzafrir Cohen wrote:

> > +if echo arch/$SRCARCH/mach-*/include | grep q -v '*'; then
> 
> This should probably be grep -q, but it's quite ugly anyway. You can
> simply run the find command and redirect it's stderr to /dev/null.

Redirect its stdout, that is. I'd prefer -q but here's a version with a
redirection.

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
