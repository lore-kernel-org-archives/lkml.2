Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1E3CHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:07:17 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:43150 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752300Ab1E3CHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:07:16 -0400
Date: Mon, 30 May 2011 12:07:12 +1000
From: CaT <cat@zip.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110530020711.GY3956@zip.com.au>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 06:30:32PM -0700, Linus Torvalds wrote:
> Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> into submission, and get scripts etc cleaned up, and the final release
> should be just "3.0". The -stable team can use the third number for
> their versioning.

Why not just keep the sublevel 0 for your release and let stable team
modify it for their release. That way you release 3.0.0, 3.1.0, 3.2.0
and stable do 3.0.1, 3.1.3, 3.2.1, etc. Less script breakage that way.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.dailytelegraph.com.au/news/wacky/indeed/story-e6frev20-1111118083480
