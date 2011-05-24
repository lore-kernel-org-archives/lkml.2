Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1EXOKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:10:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1EXOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:10:33 -0400
Date: Tue, 24 May 2011 16:10:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 0/3 rev2] fix scripts/export_report.pl
Message-ID: <20110524141031.GC2276@sepie.suse.cz>
References: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
 <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:44:54PM -0600, Jim Cromie wrote:
> thanks Randy,
> 
> rev2 fixes:
> NB -> NOTE
> cant -> cannot
> CONFIG_MODVERSION -> CONFIG_MODVERSIONS (everywhere)

Applied to kbuild-2.6.git#misc after editing the subject lines a bit:

Jim Cromie (3):
      export_report: do collectcfiles work in perl itself
      export_report: sort SECTION 2 output
      export_report: use warn() to issue WARNING, so they go to stderr

Michal
