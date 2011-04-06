Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1DFLsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:48:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48063 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab1DFLsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:48:37 -0400
Message-ID: <4D9C5309.1010700@parallels.com>
Date: Wed, 6 Apr 2011 06:48:25 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Spriggs <tims@uahirise.org>, Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] Supply network namespace to rpcbind.
References: <4D94319F.8040005@parallels.com> <20110406005743.GB27844@shutemov.name>
In-Reply-To: <20110406005743.GB27844@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 07:57 PM, Kirill A. Shutemov wrote:
> On Thu, Mar 31, 2011 at 02:47:43AM -0500, Rob Landley wrote:
>> From: Rob Landley <rlandley@parallels.com>
>>
>> The sunrpc code already has some support for network namespaces,
>> but rpcb_create() is still using init_net.  Its arguments include
>> a sockaddr and a port, but not a struct net *.  Add one, and
>> pass in the value from rpc_xprt when calling it.
>>
>> Signed-off-by: Rob Landley <rlandley@parallels.com>
> 
> Acked-by: Kirill A. Shutemov <kas@openvz.org>
> 
> BTW, it seems conflicts with my rpc_pipefs patchset. I'll rebase my
> patchset, if your patches will be merged first.

And vice versa, lemme know which order you want them in.

Thanks,

Rob
