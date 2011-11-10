Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1KJBu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:50:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:64868 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KJBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:50:58 -0500
Message-ID: <4EBB2DF3.2050504@oracle.com>
Date: Thu, 10 Nov 2011 09:50:43 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] RE: [PATCH 1/3] Introducing grant table V2 stucture
References: <4EBA35D3.3020506@oracle.com>	<1320826490-29362-1-git-send-email-annie.li@oracle.com>	<291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>	<4EBAA566.80909@oracle.com> <291EDFCB1E9E224A99088639C4762022B4543AB213@LONPMAILBOX01.citrite.net>
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B4543AB213@LONPMAILBOX01.citrite.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EBB2DFE.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-10 0:14, Paul Durrant wrote:
> Annie,
>
> On 2011-11-9 19:11, Paul Durrant wrote:
>> I see. v2 function includes mapping and arch_gnttab_map_shared, v1 function only include arch_gnttab_map_sh, right?
>> This will lead to some code duplicated in two functions.
> My preference would be to have duplicated calls to arch_gnttab_map_shared(). I think it's more illustrative of the difference between v1 and v2 having separate status pages.
Ok, will do as you suggested, thanks.

Thanks
Annie
