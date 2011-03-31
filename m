Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab1CaQGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:06:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab1CaQGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:06:06 -0400
Date: Thu, 31 Mar 2011 18:05:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@amd64.org, tglx@linutronix.de, borislav.petkov@amd.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, amd-nb: Rename CPU PCI id define for F4
Message-ID: <20110331160552.GD9827@elte.hu>
References: <20110330183447.GA3668@aftab>
 <tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
 <20110331090039.12358ee6@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331090039.12358ee6@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 31 Mar 2011 07:04:41 GMT
> tip-bot for Borislav Petkov <bp@amd64.org> wrote:
> 
> > Commit-ID:  cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> > Gitweb:     http://git.kernel.org/tip/cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> > Author:     Borislav Petkov <bp@amd64.org>
> > AuthorDate: Wed, 30 Mar 2011 20:34:47 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 31 Mar 2011 08:51:38 +0200
> > 
> > x86, amd-nb: Rename CPU PCI id define for F4
> > 
> > With increasing number of PCI function ids, add the PCI function
> > id in the define name instead of its symbolic name in the BKDG
> > for more clarity. This renames function 4 define.
> > 
> 
> I guess I don't see how a rename is urgent, but you can add my
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

The new ID went upstream via cb293250c71f in the merge window, so i wanted to 
shorten the life-time of the obsoleted name - that will also reduce the chance 
of any conflicts.

Thanks,

	Ingo
