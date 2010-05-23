Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0EWI5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:57:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:43384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0EWI5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:57:01 -0400
Message-ID: <4BF8EDDA.5050304@kernel.org>
Date: Sun, 23 May 2010 10:56:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] pci: disable MSI on VIA K8M800
References: <4BF8E5DF.6030408@kernel.org> <20100523.015426.00037797.davem@davemloft.net>
In-Reply-To: <20100523.015426.00037797.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 08:57:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 10:54 AM, David Miller wrote:
> Correctness first, of course, but saying the impact of MSI is minimal
> ignores the fact that no hardware multiqueue networking at all is
> possible without it. :-)

If you're trying to do hw multiqueue networking on via chipset, you
gotta be on something *really* good.  Come on.  Share it with me.  :-)

-- 
tejun
