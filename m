Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1CQMkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:40:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1CQMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:39:59 -0400
Date: Thu, 17 Mar 2011 13:39:58 +0100
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: fix trailing comma
Message-ID: <20110317123958.GA30807@sepie.suse.cz>
References: <20110315141347.d4ee75d3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315141347.d4ee75d3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 02:13:47PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Consolidate locations that print a section whitelist into
> calls to print_section_list().
> 
> Fix print_section_list() so that it does not print a trailing
> comma & space:
> 
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> 
> becomes:
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/mod/modpost.c |   23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
