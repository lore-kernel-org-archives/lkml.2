Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab0J2Rpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:45:30 -0400
Received: from claw.goop.org ([74.207.240.146]:51959 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0J2Rp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:45:28 -0400
Message-ID: <4CCB0836.3040200@goop.org>
Date: Fri, 29 Oct 2010 10:45:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: correct size of level2_kernel_pgt
References: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>	<4CCB02DC.1010307@goop.org> <1288373855.8069.27.camel@localhost.localdomain>
In-Reply-To: <1288373855.8069.27.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/29/2010 10:37 AM, Ian Campbell wrote:
> On Fri, 2010-10-29 at 18:22 +0100, Jeremy Fitzhardinge wrote:
>> On 10/29/2010 08:56 AM, Ian Campbell wrote:
>>> sizeof(pmd_t *) is 4 bytes on PAE leading to an allocation of only
>>> 2048 bytes. The correct size is sizeof(pmd_t) giving us a full page
>>> allocation.
>>>
>>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>>> ---
>>>
>>> Applies to mainline since 2.6.36 and to xen.git 2.6.32 based trees
>> This is just for 2.6.37?
> 2.6.36.stable too, I think. I added stable@kernel.org to my patch header
> but didn't "guilt refresh" so it didn't show up here.

The extend_brk() stuff was all merged this merge window.  I checked out
.36 to confirm, and there's nothing there for your patch to apply to...

    J
