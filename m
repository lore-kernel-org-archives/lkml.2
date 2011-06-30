Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1F3TX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:23:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1F3TX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:23:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6393"; a="101173584"
Message-ID: <4E0CCD4C.1090801@codeaurora.org>
Date: Thu, 30 Jun 2011 12:23:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>	<1306865673-20560-4-git-send-email-sboyd@codeaurora.org> <20110630121909.d4ac1bfc.akpm@linux-foundation.org>
In-Reply-To: <20110630121909.d4ac1bfc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 12:19 PM, Andrew Morton wrote:
> On Tue, 31 May 2011 11:14:32 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Strict user copy checks are only really supported on x86_32 even
>> though the config option is selectable on x86_64. Add the
>> necessary support to the 64 bit code to trigger copy_from_user()
>> warnings at compile time.
>
> So I'm getting 20-30 warnings from an x86_64 allmodconfig build.
>
> I don't think we want a million other people to have to put up with
> those warnings too.  Can you please take a look at fixing these up?
>

Care to share the warnings? I'll run a build again and fix any new
warnings I find.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

