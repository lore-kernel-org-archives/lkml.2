Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab0J2S1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:27:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33153 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab0J2S1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:27:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6151"; a="59890722"
Message-ID: <4CCB11F4.9080908@codeaurora.org>
Date: Fri, 29 Oct 2010 11:27:00 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pavel Machek <pavel@ucw.cz>, Vasiliy Kulikov <segooon@gmail.com>,
        Iliyan Malchev <ibm@android.com>, Brian Swetland <swetland@google.com>,
        San Mehat <san@android.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: dream: fix information leak to userland
References: <1288296098-18936-1-git-send-email-segooon@gmail.com> <20101028204509.GC22785@kroah.com> <20101028205831.GD19421@elf.ucw.cz> <20101028210802.GA23773@kroah.com> <4CCA2445.7070705@codeaurora.org> <20101029013843.GA9922@kroah.com>
In-Reply-To: <20101029013843.GA9922@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Greg, I'll check around internally and see if there are any concerns
>> about dropping it.  I'll get back to you soon.  Thanks.
> 
> Wonderful, thanks for doing this.
> 
> greg k-h

No concerns from us.  Feel free to drop it.  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
