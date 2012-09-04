Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2IDJPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:15:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8325 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2IDJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:15:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Sep 2012 02:15:46 -0700
Message-ID: <5045C392.8080203@nvidia.com>
Date: Tue, 4 Sep 2012 14:32:10 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] usb: otg: Move phy interface to separate file.
References: <1346222821-27650-1-git-send-email-vbyravarasu@nvidia.com> <20120903141306.GL3147@arwen.pp.htv.fi>
In-Reply-To: <20120903141306.GL3147@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Monday 03 September 2012 07:43 PM, Felipe Balbi wrote:
> * PGP Signed by an unknown key
>
> Hi,
>
> On Wed, Aug 29, 2012 at 12:17:01PM +0530, Venu Byravarasu wrote:
>> As otg.h is containing lots of phy interface related
>> stuff, moving all phy interface related stuff to new
>> file named phy.h
>>
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> this doesn't apply to my "xceiv" branch. Please rebase there so I don't
> cause any issues to your patch ;-)

Rebased the change in your tree and pushed a patch.
Plz merge.

Thanks,
Venu
