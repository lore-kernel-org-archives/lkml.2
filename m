Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1HHOCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:02:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1HHOCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:02:34 -0400
Date: Mon, 8 Aug 2011 16:02:33 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] kconfig/nconf: nuke unreferenced `nohelp_text'
Message-ID: <20110808140233.GA11427@sepie.suse.cz>
References: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 09:52:06PM -0400, Arnaud Lacombe wrote:
> After commit 5416857867c9cc94aba641898c567d9707de30f1, 1nohelp_text' is no
> longer referenced, nuke it.
> 
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/nconf.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

Applied to kbuild-2.6.git#kconfig.

Michal
