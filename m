Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2BAAuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:50:19 -0500
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:13080 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2BAAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:50:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am8IAKKLKE+rRDoJ/2dsb2JhbABDgw2pOIIogQWBcgEBAQQSAWUBEAsYCRYPCQMCAQIBRQYNAQcBAR6iPwGeUosfAQQCAQICCQICAQYHAxMBCAUDAwkcAwGCcRkEAwwDFAVXDQEEBAwCCgKDPQSIQIxghVeNHQ
X-IronPort-AV: E=Sophos;i="4.71,599,1320624000"; 
   d="scan'208";a="26398192"
Message-ID: <4F288C4A.3070509@cisco.com>
Date: Tue, 31 Jan 2012 17:50:18 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: VFs go missing with latest kernel
References: <4F287102.3060600@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com> <4F2887AB.8070005@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 05:43 PM, Rose, Gregory V wrote:
>>
>> Back to the missing VF problem: reverting the patch I mentioned before
>> and my VM boots up fine with the even-numbered VFs assigned to it.
> 
> OK, thanks... I was staring at the dmesg output you sent me and it is odd because the even numbered VFs that go missing are there when you set their MAC addresses.  See output below the dotted line after my reply.

Ah, I think I confused you. The VFs for the first 2 ports (ie., the
first 14 VFs) are seen fine; I only showed the VFs for the second 2
ports -- which are missing the even number.

So, in summary I am missing 7 VFs all associated with the even numbers
on the last ports of a quad port card.

David
