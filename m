Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab0CSW0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:26:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0CSW0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:26:49 -0400
Message-ID: <4BA3FA1D.8050204@zytor.com>
Date: Fri, 19 Mar 2010 15:26:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, cl@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
References: <alpine.DEB.2.00.1003181245050.23010@router.home>	<87tysccjrn.fsf@basil.nowhere.org> <20100319.145336.226782717.davem@davemloft.net>
In-Reply-To: <20100319.145336.226782717.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 02:53 PM, David Miller wrote:
> But I also don't consider what openpbm has to do right now to
> be all that much of a restriction.  You need privileges to
> add the protocol to the kernel, you need privileges to run
> the userspace variant, there is no real difference.

The real difference is if multiplex is needed between multiple
unprivileged users.

	-hpa
