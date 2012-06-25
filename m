Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2FYS7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:59:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2FYS7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:59:31 -0400
Date: Mon, 25 Jun 2012 11:59:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mathieu.poirier@linaro.org
Cc: linux-input@vger.kernel.org, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        kernel-team@android.com
Subject: Re: [PATCH] input: Add keyreset driver.
Message-ID: <20120625185922.GA20660@core.coreip.homeip.net>
References: <1340140414-9720-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340140414-9720-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arve,

On Tue, Jun 19, 2012 at 03:13:34PM -0600, mathieu.poirier@linaro.org wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> This patch originates from the Android tree and is being submitted
> for review and inclusion in the mainline kernel.
> 
> Add a platform device in the board file to specify a reset key-combo.
> The first time the key-combo is detected a work function that syncs
> the filesystems is scheduled. If all the keys are released and then
> pressed again, it calls panic. Reboot on panic should be set for
> this to work.

This sounds a lot like SYSRQ handler, but with configurable key sequence.
Why don't you extend drivers/tty/sysrq.c instead?

Thanks.

-- 
Dmitry
