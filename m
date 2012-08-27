Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2H0NCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:02:07 -0400
Received: from mxout1.idt.com ([157.165.5.25]:59208 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2H0NCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:02:04 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rapidio: apply RX/TX enable to active switch ports only
Thread-Topic: [PATCH] rapidio: apply RX/TX enable to active switch ports only
Thread-Index: AQHNf6i7zEEb3fHIoEStAISs7H57tJdp7hWAgAO1qQA=
Date: Mon, 27 Aug 2012 13:01:00 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D12E7C2C91@corpmail1.na.ads.idt.com>
References: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
 <1345559035-25879-2-git-send-email-alexandre.bounine@idt.com>
 <20120824140419.2b3a9623.akpm@linux-foundation.org>
In-Reply-To: <20120824140419.2b3a9623.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 24, 2012 5:04 PM
Andrew Morton <akpm@linux-foundation.org>
> 
> On Tue, 21 Aug 2012 10:23:55 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
>> Modify RIO enumeration to apply RX/TX enable operations only to
>> active switch ports. This will leave inactive ports in condition consistent
>> with their state.
> 
> It's unclear (to me) what the effects of this are.  Does it fix some
> user-visible malfunction?  Or is it just some nice-to-have thing?  Or
> what?
> 

This patch was intended to keep inactive switch ports with inbound and
outbound packet transfers disabled to block unexpected packets during
hot insertion event. While it does not fix any visible malfunction it
was intended to prevent such events in future.   

Since this patch was published it was brought to my attention that some
existing switches may require inbound and outbound ports enabled for
inactive ports as well (not spec compliant).
Therefore, please remove this patch from your tree.     

>> This patch is applicable to kernel versions starting from v2.6.35.
> 
> Is that a recommendation that such a backport be performed?  If so,
> please provide the reasoning.


