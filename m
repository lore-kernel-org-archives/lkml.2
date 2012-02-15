Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2BOLsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:48:04 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47897 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006Ab2BOLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:48:03 -0500
Subject: Re: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120214173220.GB22645@redhat.com>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <20120214173220.GB22645@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 11:47:53 +0000
Message-ID: <1329306473.3675.113.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 18:32 +0100, Oleg Nesterov wrote:
> On 02/14, Matt Fleming wrote:
> >
> > This series simplifies the architecture code for handling signals by
> > making use of set_current_blocked() introduced in e6fa16ab ("signal:
> > sigprocmask() should do retarget_shared_pending()") and
> > block_sigmask() introduced in commit 5e6292c0f28f ("signal: add
> > block_sigmask() for adding sigmask to current->blocked").
> 
> Matt, I assume this series was not changed since we discussed it ?

Correct. The only new additions are the C6X and hexagon patches here,

	https://lkml.org/lkml/2012/2/14/123
	https://lkml.org/lkml/2012/2/14/155

But they're pretty much the same as all the others in the series.

> If yes. I do not want to spam lkml, I'll reply to 0/40 only.
> 
> All patches look right to me, for the whole series:
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Great, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

