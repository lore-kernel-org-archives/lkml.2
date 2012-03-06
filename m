Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2CFOKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:10:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29969 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254Ab2CFOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:10:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6640"; a="169751760"
Message-ID: <cf2950fbeb4c500534be670cdd8cf85d.squirrel@www.codeaurora.org>
In-Reply-To: <CAKYAXd8HMrdB9mzgsz5XmMxkDE+gMce+CTEDFU4J67nusNtLOg@mail.gmail.com>
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
    <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
    <6669559e86c1d13b27e941ff2acf89d2.squirrel@www.codeaurora.org>
    <CAKYAXd8HMrdB9mzgsz5XmMxkDE+gMce+CTEDFU4J67nusNtLOg@mail.gmail.com>
Date: Tue, 6 Mar 2012 06:10:12 -0800 (PST)
Subject: Re: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Namjae Jeon" <linkinjeon@gmail.com>
Cc: merez@codeaurora.org, "Seungwon Jeon" <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, "Chris Ball" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi. Merez.
>
> Thanks a lot about your performance measurement.
>
> I think that your measurement is enough and correct and the firmware
> of mmc vender should be optimized or change properly rather than
> modifying the current patch.
>
> And currently we can use only write packed cmd by my suggestion.
>
> I would like to add my reviewd-by tag in updated patches also.
>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>
> Thanks.

I tend to disagree. Adding a massive amount of code that would be disabled
can be risky. In case this code will not be in use it will not be properly
tested and its reliability will be uncertain.

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


