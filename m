Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1EQTPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:15:24 -0400
Received: from claw.goop.org ([74.207.240.146]:48879 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab1EQTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:15:23 -0400
Message-ID: <4DD2C947.9050501@goop.org>
Date: Tue, 17 May 2011 12:15:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the xen tree with Linus tree
References: <20110115120544.98a1f091.sfr@canb.auug.org.au> <20110517211234.472e32f4.sfr@canb.auug.org.au>
In-Reply-To: <20110517211234.472e32f4.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 04:12 AM, Stephen Rothwell wrote:
> Hi Jeremy,
>
> On Sat, 15 Jan 2011 12:05:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Today's linux-next merge of the xen tree got a conflict in
>> drivers/xen/Kconfig, drivers/xen/gntdev.c and include/xen/gntdev.h
>> between various commits Linus' tree and various commits from the xen tree.
>>
>> As previously discussed, I have dropped the xen tree for today (as it
>> contains an older version of the changes that were merged into Linus'
>> tree).
> Just wondering if the xen tree is ever going to make a reappearance in
> linux-next?

Konrad's tree has the bulk of the xen work in it at the moment.  I'm
doing to start on a few bits and pieces, but I've not decided if I'll
put them into linux-next myself or just push them via Konrad.

So, maybe, but maybe not.

Thanks,
    J
