Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab0GUIh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:37:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:39902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933415Ab0GUIh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:37:28 -0400
Date: Wed, 21 Jul 2010 10:37:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] typo fix: Kconfig.debug: FAIL_IO_TIMEOUT: Faul ->
 Fault
In-Reply-To: <20100721160553.26dd6282.yoshikawa.takuya@oss.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1007211037080.4741@pobox.suse.cz>
References: <20100721160553.26dd6282.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010, Takuya Yoshikawa wrote:

> Is this typo already fixed in anybody's tree?
> I think this is config's description and worth fixing.

It's still present in linux-next, so I have applied your fix now. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
