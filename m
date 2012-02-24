Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2BXIh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:37:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:53467 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2BXIh4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Fri, 24 Feb 2012 03:37:56 -0500
Message-Id: <4F475A7002000078000748C7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 08:37:52 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Len Brown" <len.brown@intel.com>, "Shaohua Li" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.02.12 at 17:58, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Jan Beulich wrote:
>>>>> "Liu, Jinsong" <jinsong.liu@intel.com> 02/23/12 2:29 PM >>>
>>>    depends on ACPI_PROCESSOR
>>>    depends on EXPERIMENTAL
>>>    depends on X86
>>> +    default n
>> 
>> This is pointless.
> 
> Elaborate more? just a little curious why Kconfig has so many default n.

Which are all pointless afaict (and I did already get a couple of
patches merged to remove some of them) - the tool defaults
them to 'n' anyway.

Jan

