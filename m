Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GZMYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:24:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2GZMYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:24:48 -0400
Date: Thu, 26 Jul 2012 14:24:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 5/5] scripts/tags.sh: Teach [ce]tags about
 libtraceeevent error codes
Message-ID: <20120726122443.GC25512@sepie.suse.cz>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
 <1339987851-22491-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339987851-22491-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:50:51AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As we use a macro trick to sync each error codes with its
> description string, teach [ce]tags to process them properly.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Link: http://lkml.kernel.org/n/tip-qt5fv4pzigr2nnl27ydimg4h@git.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  scripts/tags.sh |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Applied to kbuild.git#misc, thanks.

Michal
