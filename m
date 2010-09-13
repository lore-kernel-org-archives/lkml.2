Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0IMPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:24:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:46416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0IMPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:24:40 -0400
Message-ID: <4C8E4236.6080108@suse.cz>
Date: Mon, 13 Sep 2010 17:24:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] make clean fixes
References: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.9.2010 13:48, Michal Marek wrote:
> Two fixes and one cleanup of 'make clean'
> 
> Michal
> 
> Michal Marek (3):
>   kbuild: Really don't clean bounds.h and asm-offsets.h
>   kbuild: Do not run make clean in $(srctree)
>   kbuild: Use a single clean rule for kernel and external modules
> 
>  Documentation/kbuild/makefiles.txt |    7 +++++++
>  Kbuild                             |    4 ++--
>  Makefile                           |   33 +++++++++++++--------------------
>  scripts/Makefile.clean             |    2 ++
>  4 files changed, 24 insertions(+), 22 deletions(-)

I added this to the kbuild tree.

Michal
