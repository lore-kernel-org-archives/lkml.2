Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab2BNRjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:39:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab2BNRi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:38:59 -0500
Date: Tue, 14 Feb 2012 18:32:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
Message-ID: <20120214173220.GB22645@redhat.com>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Matt Fleming wrote:
>
> This series simplifies the architecture code for handling signals by
> making use of set_current_blocked() introduced in e6fa16ab ("signal:
> sigprocmask() should do retarget_shared_pending()") and
> block_sigmask() introduced in commit 5e6292c0f28f ("signal: add
> block_sigmask() for adding sigmask to current->blocked").

Matt, I assume this series was not changed since we discussed it ?

If yes. I do not want to spam lkml, I'll reply to 0/40 only.

All patches look right to me, for the whole series:

Acked-by: Oleg Nesterov <oleg@redhat.com>

