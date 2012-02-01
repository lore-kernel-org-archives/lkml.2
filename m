Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2BAAah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:30:37 -0500
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:23463 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2BAAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:30:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwHAAOHKE+rRDoG/2dsb2JhbABDgw2pOIIogQWBcgEBAQQSAWUBEAsYCRYPCQMCAQIBRQYNAQcBAR6iSAGeUYsRAQQCAQICCQICAQYHAxMBCAUDAwkcAwGCcRkEAwwDFAVXDQEEBAwCCgKDPQSIQIxghVeNHQ
X-IronPort-AV: E=Sophos;i="4.71,599,1320624000"; 
   d="scan'208";a="26395537"
Message-ID: <4F2887AB.8070005@cisco.com>
Date: Tue, 31 Jan 2012 17:30:35 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: VFs go missing with latest kernel
References: <4F287102.3060600@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 03:58 PM, Rose, Gregory V wrote:
>> I am hitting some other problem trying to use the VF on 3.3.0-rc1 -- KVM
>> fails the KVM_CAP_IOMMU check though the server has one (works fine with
>> the older kernel) and it is built into the kernel. Debugging that
>> problem now.

second problem was due to a CONFIG setting.

Back to the missing VF problem: reverting the patch I mentioned before
and my VM boots up fine with the even-numbered VFs assigned to it.

David
