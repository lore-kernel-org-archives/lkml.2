Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1JLU6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:58:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:42436 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1JLU6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:58:21 -0400
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111012202332.GG21852@local>
Date: Wed, 12 Oct 2011 15:58:08 -0500
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Kai Jiang <Kai.Jiang@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <44BE1ADF-53C9-4B12-9CD1-F71A519D4CA0@kernel.crashing.org>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org> <20111012153229.GB21852@local> <20111012161931.GE21852@local> <38B65690-DA92-4923-B2A4-6523DDDA579A@kernel.crashing.org> <20111012202332.GG21852@local>
To: "Hans J. Koch" <hjk@hansjkoch.de>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2011, at 3:23 PM, Hans J. Koch wrote:

> On Wed, Oct 12, 2011 at 01:40:22PM -0500, Kumar Gala wrote:
>> 
>> On Oct 12, 2011, at 11:19 AM, Hans J. Koch wrote:
>> 
>>> On Wed, Oct 12, 2011 at 05:32:29PM +0200, Hans J. Koch wrote:
>>>> On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
>>>>> From: Kai Jiang <Kai.Jiang@freescale.com>
>>>>> 
>>>>> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
>>>>> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
>>>>> embedded PPC, ARM, and X86 have support for systems with larger physical
>>>>> address than logical.
>>>>> 
>>>>> Since 'addr' may contain a physical, logical, or virtual address the
>>>>> easiest solution is to just change the type to 'unsigned long long'
>>>>> regardless of which type is utilized.
>>>> 
>>>> No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
>>>> Please use that.
>>> 
>>> I forgot: If you resend this, please update the documentation as well.
>>> (Documentation/DocBook/uio-howto.tmpl)
>> 
>> What would you look added or modified here?
> 
> struct uio_mem ?
> 
> Hans

New version sent, let me know if there are any other aspects to the DocBook that need updating.

- k