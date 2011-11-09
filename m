Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1KIAyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:54:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42198 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab1KIAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:54:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133558240"
Message-ID: <4EB9CF2C.7040501@codeaurora.org>
Date: Tue, 08 Nov 2011 16:54:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Miche Baker-Harvey <miche@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/3] Support multiple VirtioConsoles.
References: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
In-Reply-To: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/11 11:29, Miche Baker-Harvey wrote:
> (Amit pointed out that the patches never went out. This is a resend of
> the series meant to go out on 11/2/2011; I've marked it "v2".)  
>
> This patchset applies to linux-next/next-20111102.
>
> This series implements support for multiple virtio_consoles using KVM.
>
> This patchset addresses several issues associated with trying to
> establish multiple virtio consoles. 
>
> I'm trying to start a guest via KVM that supports multiple virtual
> consoles, with getty's on each, and with some being console devices.
>
> These patches let me establish more than one VirtioConsole (I'm
> running eight at the moment), and enable console output appearing on
> one of them.  It still doesn't successfully generate console output on
> multiple VirtioConsoles.
>
> Let me apologise for my last patch having gotten into Linus' tree, and
> leaving other people to deal with crashes.  I had meant to be asking
> for guidance, but I didn't mark it as "RFC".
>
> This series reflects the input from Konrad Rzeszutek, Amit Shah, Stephen
> Boyd, and Rusty Russell.  I think we do have to limit hvc_alloc() to one
> thread.

It might be good to Cc these people in the future. I only found this
when scanning over lkml.

>
> I would appreciate any comments or feedback, or accept if appropriate.

I tested this against next-20111102 and I see duplicate messages on the
console. What's going on?

# echo hi > /dev/kmsg
[  132.960000] hi
[  132.960000] hi

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

