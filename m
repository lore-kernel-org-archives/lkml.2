Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621Ab2BNNpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:45:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab2BNNpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:45:10 -0500
Subject: Re: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Date: Tue, 14 Feb 2012 08:45:01 -0500
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1329227102.2395.58.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 11:40 +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> This series simplifies the architecture code for handling signals by
> making use of set_current_blocked() introduced in e6fa16ab ("signal:
> sigprocmask() should do retarget_shared_pending()") and
> block_sigmask() introduced in commit 5e6292c0f28f ("signal: add
> block_sigmask() for adding sigmask to current->blocked").
> 
...
> Matt Fleming (39):
...
>   C6X: Use set_current_blocked() and block_sigmask()
...
>  arch/c6x/kernel/signal.c           |   16 ++----------

The c6x patch seems to be missing from the series.

--Mark


