Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2FOK2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:28:48 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43483 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2FOK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:28:47 -0400
Date: Fri, 15 Jun 2012 12:29:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
        bp@amd64.org, pawel.moll@arm.com, jbaron@redhat.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
Message-ID: <20120615102906.GA6083@aftab.osrc.amd.com>
References: <1339711260-1349-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339711260-1349-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 04:00:59PM -0600, Jim Cromie wrote:
> main.c has initcall_level_names[] for parse_args to print in debug messages,
> add comments to keep them in sync with initcalls defined in init.h.
> 
> Also add "loadable" into comment re not using *_initcall macros in
> modules, to disambiguate from kernel/params.c and other builtins.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

This time I actually build-tested it.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
