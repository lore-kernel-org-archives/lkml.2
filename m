Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1A0Uu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:50:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0Uu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:50:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72022106"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: Clean up useless ifdefs
In-Reply-To: <1296161064.28965.10.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Thu, 27 Jan 2011 12:44:24 -0800")
References: <1296159202-13980-1-git-send-email-stepanm@codeaurora.org>
	<1296161064.28965.10.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110127:stepanm@codeaurora.org::XRFkfgC8BK2eOhjn:0000000000000000000000000000000000000000RhA
X-Hashcash: 1:20:110127:linux-arm-kernel@lists.infradead.org::6wrdI9jkQacTgaKr:000000000000000000000000034od
X-Hashcash: 1:20:110127:dwalker@codeaurora.org::phA2uLxPxN9eqnbC:0000000000000000000000000000000000000004UlQ
X-Hashcash: 1:20:110127:linux-kernel@vger.kernel.org::aWgb+wWssaiPyk4W:0000000000000000000000000000000005e2V
X-Hashcash: 1:20:110127:linux-arm-msm@vger.kernel.org::31ajI+14QiOG5SqT:00000000000000000000000000000000GL3R
Date: Thu, 27 Jan 2011 12:50:25 -0800
Message-ID: <8yaoc723wby.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27 2011, Daniel Walker wrote:

> On Thu, 2011-01-27 at 12:13 -0800, Stepan Moskovchenko wrote:
>> Remove ifdefs that do nothing, either from having the code
>> between them previously removed, or from having been
>> accidentally added to the wrong file.
>> 
>> Change-Id: I94aac2cb24e23ba7f8b4b158ce6653dc3b786989
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>
> You need to drop the Change-Id: ..

If there aren't any other concerns raised, I can pull these off when I
pull in these changes.  But, yes, in generall, they shouldn't be
present.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
