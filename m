Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1GYM64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:58:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1GYM6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:58:51 -0400
Date: Mon, 25 Jul 2011 14:58:48 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Richard Henderson <rth@tamu.edu>, Bjorn Ekwall <bj0rn@blox.se>,
        trivial@kernel.org
Subject: Re: [PATCH] genksyms: Use same type in loop comparison
Message-ID: <20110725125848.GD4482@sepie.suse.cz>
References: <alpine.LNX.2.00.1107120030040.10944@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107120030040.10944@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:32:04AM +0200, Jesper Juhl wrote:
> The ARRAY_SIZE macro in scripts/genksyms/genksyms.c returns a value of
> type size_t. That value is being compared to a variable of type int in
> a loop in read_node(). Change the int variable to size_t type as well,
> so we don't do signed vs unsigned type comparisons with all the
> potential promotion/sign extension trouble that can cause (also
> silences compiler warnings at high levels of warnings).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied to kbuid-2.6.git#kbuild, thanks.

Michal
