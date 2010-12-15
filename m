Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0LOPil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:38:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12636 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0LOPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:38:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66726903"
Date: Wed, 15 Dec 2010 07:38:38 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] msm: Physical offset for MSM8960
Message-ID: <20101215153837.GB15817@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
 <4D08BFFC.3020103@ru.mvista.com>
 <20101215135508.GB8682@huya.qualcomm.com>
 <1292424054.13887.5.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292424054.13887.5.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 06:40:54AM -0800, Daniel Walker wrote:

> > > -#elif defined(CONFIG_ARCH_MSM8X60)
> > > +#elif defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)
> > 
> > I guess it's a matter of style, and what one is trying to emphasize.
> > Having each one listed makes it easier to change them individually.
> > The file is just a listing of the addresses of each chip, so I don't
> > see much reason to try and compact it.
> 
> It just shows a deeper issue, that the namespace needs work. There's too
> much duplication here vs. 8x60 .. If you look over this whole patchset
> it looks very much like 8x60 was just copied over.

There's not very much copying here, in fact there isn't very much to
the 8960 support to begin with.  Despite the confusing names, 8960 is
quite a bit different from 8[26]60.  I agree we would probably be best
with different names, which might help make the difference clearer.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
