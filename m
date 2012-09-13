Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2IMTpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:45:21 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52069 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2IMTpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:45:17 -0400
Subject: Re: [PATCH] Xen backend support for paged out grant targets.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Andres Lagar-Cavilla <andres.lagarcavilla@gmail.com>
In-Reply-To: <1347559899.25803.64.camel@dagon.hellion.org.uk>
Date: Thu, 13 Sep 2012 15:45:14 -0400
Cc: Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        "xen-devel@xen.lists.org" <xen-devel@xen.lists.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <B4C805E1-3390-4002-BECC-7D1AFF2BD56D@gmail.com>
References: <1347557306-25453-1-git-send-email-andres@lagarcavilla.org> <1347559899.25803.64.camel@dagon.hellion.org.uk>
To: Ian Campbell <Ian.Campbell@citrix.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 13, 2012, at 2:11 PM, Ian Campbell wrote:

> On Thu, 2012-09-13 at 18:28 +0100, Andres Lagar-Cavilla wrote:
>> 
>> * Add placeholder in array of grant table error descriptions for
>> unrelated error code we jump over. 
> 
> Why not just define it, it's listed here:
> http://xenbits.xen.org/docs/unstable/hypercall/include,public,grant_table.h.html#Enum_grant_status
Well, a) we'd be defining something no one will be using (for the moment) b) I would be signing-off on something unrelated.
> 
> I notice the specific wording of the error msg is different here too.
That should not be, I'll re-spin the patch.

Thanks
Andres

> It'd probably be best to use the same wording as the Xen definition, so
> all OSes end up with the same name for the same condition (else bug
> reports will be confusing).
> 
> Ian.
> 

