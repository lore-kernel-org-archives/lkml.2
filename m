Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1HIHBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:01:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33412 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1HIHBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:01:18 -0400
Date: Tue, 9 Aug 2011 00:01:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Chris Leech <christopher.leech@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        "Gong, Michael" <Michael.Gong@atmel.com>
Subject: Re: [PATCH v2] Input: atmel_mxt_ts - Report pressure information
 from the driver
Message-ID: <20110809070110.GC8017@core.coreip.homeip.net>
References: <1311787695-28147-1-git-send-email-miletus@chromium.org>
 <20110730191206.GF5686@core.coreip.homeip.net>
 <CAPDwgkOpBg911PjoAb1ywv769nC63QDAJgUSES+3PmRsMENMHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDwgkOpBg911PjoAb1ywv769nC63QDAJgUSES+3PmRsMENMHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yufeng,

On Wed, Aug 03, 2011 at 12:22:19PM -0400, Yufeng Shen wrote:
> Hi Dmitry,
> 
> Currently the driver atmel_mxt_ts.c supports 3 different models of
> atmel touch controller:
> 
> 1. qt602240_ts
> 2. atmel_mxt_ts   (which is for mxt1386)
> 3. mXT224
> 
> Confirmed with atmel side that qt602240_ts is actually an alias for
> mxt224, and mxt224
> follows the same protocol guide with mxt1386, which means it will
> report the pressure
> information the same way as mxt1386.

Great, thanks for confirming that. Can I please have your
"Signed-off-by:" so I can apply the patch?

-- 
Dmitry
