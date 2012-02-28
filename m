Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2B1AC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:02:59 -0500
Received: from tundra.namei.org ([65.99.196.166]:57994 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab2B1AC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:02:58 -0500
Date: Tue, 28 Feb 2012 11:02:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] security: fix ima kconfig warning
In-Reply-To: <4F47E4C5.7060706@xenotime.net>
Message-ID: <alpine.LRH.2.02.1202281102260.23213@tundra.namei.org>
References: <4F47E4C5.7060706@xenotime.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix IMA kconfig warning on non-X86 architectures:

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


- James
-- 
James Morris
<jmorris@namei.org>
