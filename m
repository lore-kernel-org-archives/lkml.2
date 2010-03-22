Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0CVUFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:05:36 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:54423 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751259Ab0CVUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:05:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y8IYv02/Mw278jY3AUTh0eDIwb74JfLrpeNs/0Sm6WaKomYgGruX+jKIHPkM38huG9dV2KpdtSEcxUr+2Y26LHKgoRee7DpQAidBZvrDt/hYTwXj1xAn6CLpAoK8WK7F;
Date: Mon, 22 Mar 2010 13:05:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, kgdb-bugreport@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] Re: [Kgdb-bugreport] [GIT PULL] V2 kdb / early debug
 (1 of 2) for 2.6.34
Message-ID: <20100322130530.50e8de1e@jbarnes-piketon>
In-Reply-To: <4BA58100.2000104@windriver.com>
References: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com>
	<4BA58100.2000104@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 21:14:24 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> On 02/28/2010 11:09 PM, Jason Wessel wrote:
> > Linus please pull the kdb-merge tree which merges the kdb front end
> > into the kernel debug core for 7 architectures.
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb-merge
> >   
> 
> What is the status of this pull request?  Was some part of the process
> missed here that there has been no response on this pull request?
> 
> Please let me know what is wrong here.   I have a number of other fixes
> pending to the tree at this point.
> 
> Would it be possible to merge part of the tree that is only related to
> kgdb, in particular the directory re-organization?

IIRC he still had some issues with the keyboard/input handling.  We
discussed it briefly a couple of weeks ago and he was worried about
potential duplication.

This may all be slander though; if so hopefully he'll recover from his
email backlog and respond to this. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
