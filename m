Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0FNXIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:08:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44430 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0FNXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:08:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jun 2010 01:07:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Edward Shishkin <edward.shishkin@gmail.com>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       clemens@ladisch.de, debora@linux.vnet.ibm.com,
       dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org
In-Reply-To: <4C16B236.7080506@gmail.com>
Message-ID: <tkrat.d7bea45e7dbad972@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
 <4C1699AA.3000900@gmail.com> <4C169D71.90800@gmail.com>
 <4C16A372.6020604@gmail.com> <4C16B236.7080506@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Jun, Justin P. Mattock wrote:
> On 06/14/2010 02:47 PM, Edward Shishkin wrote:
>> Whitespaces should be removed.
>> I recommend quilt package for managing patches:
>> "quilt refresh --strip-trailing-whitespace" is your friend..
> 
> o.k. I resent this.. fixed the whitespace(hopefully)
> and add your Acked to it.
> as for quilt I'll have to look into that..
> (using a lfs system, so if the sourcecode is easy
> to deal with(build), then it's a good but if it becomes
> a nightmare maybe not!!).

Since you appear to generate the patches with git, you can use "git diff
--check [...]" for some basic whitespace checks (additions of trailing
space, additions of space before tab).  For more extensive checks, try
"git diff [...] | scripts/checkpatch.pl -".  Check this before you
commit.  If you committed already, "git commit --amend [-a] [...]" lets
you alter the very last commit of course.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

