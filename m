Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2FMH66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:58:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63064 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2FMH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:58:57 -0400
Date: Wed, 13 Jun 2012 09:58:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com, joe@perches.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] watchdog: Quiet down the boot messages
Message-ID: <20120613075852.GB18819@gmail.com>
References: <1339448655-28060-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339448655-28060-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> After the change, it is simplified to:

>     NMI watchdog enabled, takes one hw-pmu counter.

minor nit, the above line in the changelog does not match the 
code anymore.

> +	static unsigned long cpu0_err;

Please don't use statics inside functions - move it to file 
scope, before the function or so.

Thanks,

	Ingo
