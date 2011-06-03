Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1FCUi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:38:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49574 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab1FCUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:38:55 -0400
Date: Fri, 3 Jun 2011 13:38:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, paulmck@linux.vnet.ibm.com,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110603203804.GS4376@outflux.net>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
 <1307133252-23259-5-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307133252-23259-5-git-send-email-wad@chromium.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 03:34:04PM -0500, Will Drewry wrote:
>  Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
>  implemented presently, and what it may be used for.  In addition,
>  the limitations and caveats of the proposed implementation are
>  included.

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
