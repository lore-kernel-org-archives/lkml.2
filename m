Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1LGK2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:28:01 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28059 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1LGK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:27:57 -0500
Message-ID: <4EDF3F9B.4030407@oracle.com>
Date: Wed, 07 Dec 2011 18:27:39 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com>	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>	 <1323171726.23681.65.camel@zakaz.uk.xensource.com>	 <4EDEDF2E.3040204@oracle.com>	 <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net> <1323251849.23681.128.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323251849.23681.128.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EDF3FA9.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-7 17:57, Ian Campbell wrote:
> On Wed, 2011-12-07 at 08:59 +0000, Paul Durrant wrote:
>>> gnttab_v2_ops = {
>>>    ...
>>> .access_subpage = access_subpage_v2;
>>> .access_ref_subpage = access_ref_subpage_v2; .access_trans =
>>> access_trans_v2; .access_ref_trans = access_ref_trans_v2; }
>>>
>>
>> Do you need ops for the ref and non-ref functions? I would have
>> thought you could just have the ref ones since the all the non-ref
>> variants do is allocate and then call the ref variant.
> Good point. It appears that all the existing ops are only present in the
> ref form.
So I will add two elements: access_ref_subpage and access_ref_trans into 
gnttab_v2_ops.

Thanks
Annie
> Ian.
>
>
