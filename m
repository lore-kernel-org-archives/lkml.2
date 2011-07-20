Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1GTPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:12:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab1GTPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:12:22 -0400
Date: Wed, 20 Jul 2011 17:12:19 +0200
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH V3] kbuild: silence generated makefile message
Message-ID: <20110720151219.GC4482@sepie.suse.cz>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
 <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
 <alpine.LNX.2.00.1106271915160.38876@linux>
 <alpine.LNX.2.00.1106271932480.13060@linux>
 <20110701134733.GB25895@sepie.suse.cz>
 <alpine.LNX.2.00.1107041852390.20463@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107041852390.20463@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 06:55:23PM -0400, Peter Foley wrote:
> This patch silences the "make -C /usr/src/git O=/usr/src/git/build/." 
> message shown when using the generated makefile in KBUILD_OUTDIR.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
> V2: Show message when V=1
> V3: Check if V=1 comes from the commandline

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
