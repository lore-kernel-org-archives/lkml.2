Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2IFIUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:20:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55281 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2IFIUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:20:34 -0400
Date: Thu, 6 Sep 2012 13:50:24 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
	(powerpc tree related)
Message-ID: <20120906082024.GB362@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120906171153.c80e87ea8db3dd3f4ac87cf5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906171153.c80e87ea8db3dd3f4ac87cf5@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090608-5518-0000-0000-0000076831D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:11:53PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> In file included from drivers/atm/fore200e.c:70:0:
> drivers/atm/fore200e.h:263:3: error: redefinition of typedef 'opcode_t' with different type
> arch/powerpc/include/asm/probes.h:25:13: note: previous declaration of 'opcode_t' was here
> 
> Caused by commit 7118e7e648e0 ("powerpc: Consolidate {k,u}probe
> definitions") from the powerpc tree.
> 
> I have reverted that commit (and the two following:
> 41ab5266c362	"powerpc: Add trap_nr to thread_struct"
> 8b7b80b9ebb4	"powerpc: Uprobes port to powerpc")
> for today.

Hi Stephen,

I have just posted a patch [1] to fix the issue.

Ananth

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2012-September/100813.html

