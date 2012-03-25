Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2CYRt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:49:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63613 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2CYRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:49:26 -0400
Date: Sun, 25 Mar 2012 21:49:10 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-ID: <20120325174910.GA10883@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <201203250924.06908.a.miskiewicz@gmail.com>
 <20120325153612.GC4391@albatros>
 <201203251940.58668.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203251940.58668.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 19:40 +0200, Arkadiusz Miśkiewicz wrote:
> I wonder if it should support noxx options then (like nogid, nohidepid) ? 

hidepid=0 is "nohidepid".  It is described in Documentation/filesystems/proc.txt.

gid makes sense only when hidepid > 0, so there is no sense in nogid.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
