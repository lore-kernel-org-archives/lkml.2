Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851Ab2ILRJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:09:51 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62557 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760568Ab2ILRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:09:48 -0400
Date: Wed, 12 Sep 2012 10:09:43 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/perf/core] perf probe: Add union member access
 support
Message-ID: <20120912170943.GE10019@ghostprotocols.net>
References: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 04:57:45PM +0900, Hyeoncheol Lee escreveu:
> +++ b/tools/perf/util/probe-finder.c
> @@ -525,8 +525,10 @@ static int convert_variable_fields(Dwarf_Die
> *vr_die, const char *varname,


[acme@sandy linux]$ am /wb/1.patch 
Applying: perf probe: Add union member access support
fatal: corrupt patch at line 10
Patch failed at 0001 perf probe: Add union member access support
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
[acme@sandy linux]$ git am --abort
[acme@sandy linux]$ patch -p1 < /wb/1.patch 
patching file tools/perf/util/probe-finder.c
patch: **** malformed patch at line 60: *vr_die, const char *varname,

[acme@sandy linux]$

I'm fixing this up for you this time, but please fix your MUA.

- Arnaldo
