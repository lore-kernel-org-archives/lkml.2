Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2IYISy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:18:54 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:33562 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab2IYISw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <1348545276.18124.0.camel@phoenix>
References: <1348545276.18124.0.camel@phoenix>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 25 Sep 2012 13:48:30 +0530
Message-ID: <CAMQu2gy79MxeumgrXQV3E9Cv+MNiDTcm=pfCE8hYMqdHZtKngQ@mail.gmail.com>
Subject: Re: [PATCH] memory: emif: Add ifdef CONFIG_DEBUG_FS guard for emif_debugfs_[init|exit]
To: Axel Lin <axel.lin@ingics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Tue, Sep 25, 2012 at 9:24 AM, Axel Lin <axel.lin@ingics.com> wrote:
>
> Add ifdef CONFIG_DEBUG_FS guard for emif_debugfs_[init|exit], and adds
> stub
> functions for the case CONFIG_DEBUG_FS is not set.
>
> When CONFIG_DEBUG_FS is enabled, debugfs_create_dir and
> debugfs_create_file
> return NULL on failure, fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
Patch looks good to me. Thanks for the fix.

Acked-by : Santosh Shilimkar <santosh.shilimkar@ti.com>

Greg,
Will you able to pick this fix ?

Regards,
Santosh
