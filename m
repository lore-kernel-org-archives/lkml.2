Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2GEUf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:35:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41870 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2GEUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:35:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6763"; a="205422637"
Message-ID: <4FF5FA9B.4070003@codeaurora.org>
Date: Thu, 05 Jul 2012 13:35:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each
 rproc
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <4FC5DBFA.2030300@codeaurora.org> <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com> <CAK=WgbbREXV8nkF4vh9iLUp1WQj2ZLYW6VG8Urmw9=roy63meQ@mail.gmail.com> <4FF1F145.2050408@codeaurora.org> <CAK=WgbZ+=MGU5juuOP+_vtUe4d_46j=Rd0cqYi7q2i-9T35R5w@mail.gmail.com>
In-Reply-To: <CAK=WgbZ+=MGU5juuOP+_vtUe4d_46j=Rd0cqYi7q2i-9T35R5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/12 12:54, Ohad Ben-Cohen wrote:
> On Mon, Jul 2, 2012 at 10:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Great! It looks like device_type doesn't have any list iteration support
>> though. Is that requirement gone?
> Pretty much, yeah. I'll soon post a separate patch which removes the
> get_by_name functionality (together with its related klist).
>
>> Will you resend this as part of a series? It will be easier to review then.
> Not sure. There's a collection of discrete patches that I've been
> posting, but they really aren't an organic series: as long as the
> dependencies are met, each and every one of them is applicable even if
> applied alone.
>
> So I'd prefer (when possible) to treat patches in a discrete fashion
> so we can start applying them and unblock others who depend on them
> (e.g. Fernando's runtime PM work depends on this one).
>
> But if you prefer me to send this one patch differently to make it
> easier to review, let me know!
>

Ok then. Please add

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

It would be nice if you got an ack from Greg or Kay on the device_type
usage too.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

