Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab1CDXDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:03:20 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57234 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1CDXDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <9d6dd47e36dafad4e2f876d994f607e2.squirrel@www.codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
	<1299100671-11665-1-git-send-email-carlv@codeaurora.org>
	<9d6dd47e36dafad4e2f876d994f607e2.squirrel@www.codeaurora.org>
Date: Fri, 4 Mar 2011 15:03:17 -0800
Message-ID: <AANLkTin7EDr8e3bpMwZuUWdvDs6Bj+xDnYUaShZTfmwx@mail.gmail.com>
Subject: Re: [PATCH 3/4] [ARM] msm_fb: Fix framebuffer console
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Carl Vanderlip <carlv@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 1:26 PM, Carl Vanderlip <carlv@codeaurora.org> wrote:
> On Wed, 2011-03-02 at 13:17 -0800, Carl Vanderlip wrote:
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> Don't allow non panning updates to bypass the wait for the panel to turn
> on.
>>
>> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
>
> Arve,
>
>        This patch did not have a SOB from you. Would you sign off on this patch?
>

Yes, you can add a sign-off and/or ack by me.

-- 
Arve Hjønnevåg
