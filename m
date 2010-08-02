Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0HBSQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:16:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0HBSQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:16:19 -0400
Message-ID: <4C570B6C.201@zytor.com>
Date: Mon, 02 Aug 2010 11:16:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: hp fk <fkhp101@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com> <215375.1280753770@localhost> <AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com> <6501.1280759131@localhost>            <AANLkTik8DSLFeGqHspYjykt_vCF7SxupKSxKcB2LLRhj@mail.gmail.com> <8023.1280761746@localhost>
In-Reply-To: <8023.1280761746@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:09 AM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 02 Aug 2010 23:02:01 +0800, you said:
> 
>>  HTTP if more of an access protocol,the logical network is woven in
>> the web page controled by html, the network needed is formed and take
>> part in by tcp/ip protocol which usually lies in kernel.
>>
>> Kademlia itself has the responsibility to weave the p2p network and
>> bring a node into the p2p network before access can be done.
> 
> You're still failing to explain why the kernel needs to do this
> rather than some -lkademlia in userspace.
> 

Specifically, the reasons a network protocol goes in the kernel is
either because it needs a multiplex that isn't possible in userspace
(UDP, for example, needs a port number multiplex), or because acceptable
performance isn't possible in userspace (this mostly applies to NFS.)

	-hpa

