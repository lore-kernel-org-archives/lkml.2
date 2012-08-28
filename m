Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2H1Im1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:42:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57486 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2H1ImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:42:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120809175712.GA24215@codeaurora.org>
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr>
 <1344008414-2894-6-git-send-email-damien.cassou@lifl.fr> <20120809175712.GA24215@codeaurora.org>
From: Damien Cassou <damien.cassou@gmail.com>
Date: Tue, 28 Aug 2012 10:42:04 +0200
Message-ID: <CA+y5gggtPjPFFvTM5DKEfAALA5p7m96=_j6wBGmc4S7iW5Tk8w@mail.gmail.com>
Subject: Re: [PATCH 4/5] drivers/video/msm/mddi_client_dummy.c: use devm_ functions
To: David Brown <davidb@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 7:57 PM, David Brown <davidb@codeaurora.org> wrote:
> Removing this block causes a warning:
> kernel/drivers/video/msm/mddi_client_dummy.c: In function 'mddi_dummy_probe':
> kernel/drivers/video/msm/mddi_client_dummy.c:55:6: warning: unused variable 'ret' [-Wunused-variable]
>
> Please remove the 'int ret;' line above as well.

Thank you for your feedback.
Please ignore this thread and patch. I've just sent a new email with
corrected patch.

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
