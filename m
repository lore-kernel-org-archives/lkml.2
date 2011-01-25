Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1AYBxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:53:15 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49811 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1AYBxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:53:14 -0500
Message-ID: <4D3E2D00.8050007@parallels.com>
Date: Mon, 24 Jan 2011 19:53:04 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kas@openvz.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, <linux-nfs@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        <containers@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/16] make rpc_pipefs be mountable multiple time
References: <1295012954-7769-1-git-send-email-kas@openvz.org> <20110124235545.GA793@shutemov.name>
In-Reply-To: <20110124235545.GA793@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.27.19.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 05:55 PM, Kirill A. Shutemov wrote:
> On Fri, Jan 14, 2011 at 03:48:58PM +0200, Kirill A. Shutemov wrote:
>> Prepare nfs/sunrpc stack to use multiple instances of rpc_pipefs.
>> Only for client for now.
>>
>> It's step forwart to get nfs work from container.
> 
> Any feedback?

I didn't see anything to object to, and I'll give a:

Reviewed-by: Rob Landley <rlandley@parallels.com>

To the one that you rewrote for me (um, 12/16).  I still don't
understand at the design level why init_rpc_pipefs exists if containers
don't need it, but it seems to be implementing what it sets out to do.

But it doesn't apply to my test environment (nfsv3 unauthenticated), and
I'm still trying to finish up that before switching gears to look at v4.

Rob
