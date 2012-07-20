Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2GTOOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:14:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42175 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2GTOOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:14:03 -0400
Message-ID: <500964A7.1020702@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 09:01:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/4] powerpc/crypto: add 842 hardware compression driver
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com> <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com> <1342762410.15356.7.camel@concordia>
In-Reply-To: <1342762410.15356.7.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072014-9360-0000-0000-000008962C94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 12:33 AM, Michael Ellerman wrote:
> On Thu, 2012-07-19 at 09:42 -0500, Seth Jennings wrote:
>> This patch adds the driver for interacting with the 842
>> compression accelerator on IBM Power7+ systems.
> 
> ...
> 
>> +struct nx842_slentry {
>> +	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
>> /+	unsigned long len;
>> +};
> 
> These days virt_to_abs() is just __pa() - ie. convert to a real address.

Thanks, I'll make that change.

Is it a blocker to the code being pulled in though? I'm
hoping to get this in ASAP for the 3.6 merge window.  As
this isn't a functional defect (I assume __pa() and
virt_to_abs() still achieve the same result), can I get an
OK from you that this isn't a blocker to the code being
accepted?

I'll submit a patch later to make this change.

Thanks again!

Seth

