Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab2KVWte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:49:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35120 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2KVSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:01 -0500
Message-ID: <50ADCA18.4080004@nvidia.com>
Date: Wed, 21 Nov 2012 23:45:44 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
References: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com> <20121121.144727.1842286617829159643.hdoyu@nvidia.com>
In-Reply-To: <20121121.144727.1842286617829159643.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 05:47 AM, Hiroshi Doyu wrote:
> From 2257f87f95c3982aac7c30389357db66f597c083 Mon Sep 17 00:00:00 2001
> From: Hiroshi Doyu <hdoyu@nvidia.com>
> Date: Thu, 15 Nov 2012 08:28:39 +0200
> Subject: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
> 
> Fix build warning w/o PM_SLEEP.

Hiroshi,

I'm getting 2 copies of all these patches; a normal-looking patch
followed by what looks like an mbox file in the message body, or
something like that. Also, the patches are all "to" a mailing list, and
"cc" various people, whereas they should usually be "to" the people you
expect to apply the patch, and "cc" any other people and mailing lists.
I'm off work on holidays right now, returning on the 26th and will look
into which of these patches I should/shouldn't be taking myself when I
get back.
