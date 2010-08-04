Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0HDRRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:17:25 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:42980 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0HDRRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:17:23 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Topic: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Index: AcszLH4zXLsEPQuASP+5uxzSPyjpcgAQLtUAAAgzgxAAKOwtAAAOQtlQ
Date: Wed, 4 Aug 2010 17:17:21 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE8EF5@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100804170406.GA28217@suse.de>
In-Reply-To: <20100804170406.GA28217@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>And then Greg spoke:
>> And then Greg spoke:
> >>>On Tue, Aug 03, 2010 at 05:31:51PM +0000, Hank Janssen wrote:
> >>> From: Hank Janssen <hjanssen@microsoft.com>
> >>> 
> >> >Fixed bounce offset kmap problem by using correct index
> >>

SNIP

> > I actually goofed up in my previous code and used an incorrect index 
> > number For this part of the code. It should have shown up in more 
> > situations than what I have seen oddly enough.
>
>Please provide this type of information in the changelog section.
>
>If you want something backported to older stable kernels, add a:
>	Cc: stable <stable@kernel.org>

I will re-submit all 5 patches and CC the stable mailing list on it as well.

Thanks!

Hank.

