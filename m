Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab0KRVFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:05:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0KRVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:05:20 -0500
Date: Thu, 18 Nov 2010 13:03:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, justinmattock@gmail.com, eric.dumazet@gmail.com,
        linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, horms@verge.net.au,
        netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
Message-Id: <20101118130318.073f6beb.randy.dunlap@oracle.com>
In-Reply-To: <20101118.125451.98885354.davem@davemloft.net>
References: <4CE56E89.4000902@trash.net>
	<4CE57C06.4080105@gmail.com>
	<4CE58D4B.6070105@trash.net>
	<20101118.125451.98885354.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 12:54:51 -0800 (PST) David Miller wrote:

> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 18 Nov 2010 21:32:11 +0100
> 
> > Thanks for testing. Dave, please apply directly, thanks!

Dave,

This patch does not fix the config/build error that I posted for linux-next.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
