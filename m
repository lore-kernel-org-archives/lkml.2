Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1C3KpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:45:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38383 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab1C3KpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:45:20 -0400
Message-ID: <4D9309B4.2000501@parallels.com>
Date: Wed, 30 Mar 2011 05:45:08 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <stable@kernel.org>
Subject: Re: 2.6.38 containers bug: Infinite loop in /proc/sys/net/ipv6/neigh/neigh/neigh...
References: <4D92E9DC.3070405@parallels.com>	<20110330.020120.02272125.davem@davemloft.net>	<4D9302F3.6080206@parallels.com> <20110330.033529.71582712.davem@davemloft.net>
In-Reply-To: <20110330.033529.71582712.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 05:35 AM, David Miller wrote:
> From: Rob Landley <rlandley@parallels.com>
> Date: Wed, 30 Mar 2011 05:16:19 -0500
> 
>> Pinging the stable guys to make sure this goes in a dot release.
> 
> Please do not do this.

Too late, but presumably they got your NAK.

> I let fixes soak in Linus's tree for a week or even more before I submit
> them to -stable.

So you think letting it soak in the merge window and the churn of -rc1
(which currently doesn't boot for me due to an ide issue) will provide
more validity than a specific "There was an infinite loop in the
filesystem, there is now no longer an infinite loop in the filesystem,
here's the specific test for it" and visual inspection ofthe patch?

*shrug*  I hear what you say.  It's certainly a point of view.

Rob
