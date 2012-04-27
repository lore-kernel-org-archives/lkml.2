Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab2D0PrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:47:16 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:59010 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760233Ab2D0PrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:47:15 -0400
Message-ID: <4F9ABF9C.2070707@xenotime.net>
Date: Fri, 27 Apr 2012 08:47:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
In-Reply-To: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 11:11 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120424:



uml on x86_64 (defconfig):

mm/memcontrol.c:256:30: error: 'HUGE_MAX_HSTATE' undeclared here (not in a function)


-- 
~Randy
