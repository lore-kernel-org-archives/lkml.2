Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0LORxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:53:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41392 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0LORxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:53:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66743374"
Message-ID: <4D0900A7.8070405@codeaurora.org>
Date: Wed, 15 Dec 2010 09:53:43 -0800
From: Steve Muckle <smuckle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101019 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] msm: Physical offset for MSM8960
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1292384961-8851-3-git-send-email-stepanm@codeaurora.org> <4D08BFFC.3020103@ru.mvista.com> <20101215135508.GB8682@huya.qualcomm.com> <1292424054.13887.5.camel@m0nster> <20101215153837.GB15817@huya.qualcomm.com>
In-Reply-To: <20101215153837.GB15817@huya.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/10 07:38, David Brown wrote:
> There's not very much copying here, in fact there isn't very much to
> the 8960 support to begin with.  Despite the confusing names, 8960 is
> quite a bit different from 8[26]60.  I agree we would probably be best
> with different names, which might help make the difference clearer.

A couple more comments here...

Currently it is the case that there is a lot of similarity between 8960
and 8660, however the two are expected to diverge as 8960 support
matures. This may include things like the physical offset so IMO it is
better to leave this things as per-ARCH rather than combining them.

During some previous discussions on the naming situation, one idea which
was floated was renaming 8x60 to 8660, which would help clarify the
difference from 8960. The only issue with that is that 8260, which is
for purposes of the kernel the same as 8660, would be left out and
probably just have to be mentioned in the Kconfig help text for 8660.

thanks,
Steve

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
