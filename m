Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab0HDSu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:50:28 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:58108 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab0HDSu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:50:26 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Topic: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Index: AcszLH4zXLsEPQuASP+5uxzSPyjpcgAQLtUAAAgzgxAAKOwtAAAOQtlQ//+kCgD//5I6iA==
Date: Wed, 4 Aug 2010 18:50:24 +0000
Message-ID: <81D58C97-B9A7-4217-9912-7EE6A3FE7DD0@microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100804170406.GA28217@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8EF5@TK5EX14MBXC114.redmond.corp.microsoft.com>,<20100804182318.GB29046@suse.de>
In-Reply-To: <20100804182318.GB29046@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org







On Aug 4, 2010, at 11:26, Greg KH <gregkh@suse.de> wrote:

> On Wed, Aug 04, 2010 at 05:17:21PM +0000, Hank Janssen wrote:
>>> 
>> 
>> I will re-submit all 5 patches and CC the stable mailing list on it as well.
> 
> 5?  I see 6 of them here :)
> 
> thanks,
> 
> greg k-h
> 

True but anise you rejected the todo patch there will only be 5.
Unless you are willing to take the todo patch. :)

Hank. 