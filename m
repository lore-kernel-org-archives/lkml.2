Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1BPCUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:20:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55140 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1BPCUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:20:11 -0500
X-BOX-Message-Id: p1G2K1Tq001185
Message-ID: <4D5B3419.7010909@realsil.com.cn>
Date: Wed, 16 Feb 2011 10:19:05 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rts_pstor: fix sparse warning
References: <1297820618-11962-1-git-send-email-wei_wang@realsil.com.cn> <20110216020944.GA29648@suse.de>
In-Reply-To: <20110216020944.GA29648@suse.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg:

Do you mean that exactly one modification corresponds to one patch? Such
as, if I add 2 static modifier and delete one function, I should send 3
patches?

wwang

于 2011年02月16日 10:09, Greg KH 写道:
> On Wed, Feb 16, 2011 at 09:43:38AM +0800, wei_wang@realsil.com.cn wrote:
>> From: wwang <wei_wang@realsil.com.cn>
>>
>> Add static modifier before some function definitions; delete function
>> named rtsx_transfer_sglist which won't be called.
> Thanks for describing this better.
>
> And now that we can easily see that you are doing more than one thing in
> this patch, please redo it, only doing one-thing-per-patch as is the way
> we require patches to be.
>
> Care to resend this as a series of patches?
>
> thanks,
>
> greg k-h

