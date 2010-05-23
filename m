Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0EWI6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:58:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35640
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab0EWI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:58:02 -0400
Date: Sun, 23 May 2010 01:58:12 -0700 (PDT)
Message-Id: <20100523.015812.98025271.davem@davemloft.net>
To: tj@kernel.org
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] pci: disable MSI on VIA K8M800
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BF8EDDA.5050304@kernel.org>
References: <4BF8E5DF.6030408@kernel.org>
	<20100523.015426.00037797.davem@davemloft.net>
	<4BF8EDDA.5050304@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sun, 23 May 2010 10:56:58 +0200

> On 05/23/2010 10:54 AM, David Miller wrote:
>> Correctness first, of course, but saying the impact of MSI is minimal
>> ignores the fact that no hardware multiqueue networking at all is
>> possible without it. :-)
> 
> If you're trying to do hw multiqueue networking on via chipset, you
> gotta be on something *really* good.  Come on.  Share it with me.  :-)

Fair enough. :)
