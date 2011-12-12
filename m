Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1LLHcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:32:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60165 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1LLHcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:32:22 -0500
Message-ID: <4EE5ADF7.7080400@oracle.com>
Date: Mon, 12 Dec 2011 15:32:07 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V3 1/2] xen/granttable: Support sub-page grants
References: <1323430321-5465-1-git-send-email-annie.li@oracle.com>	 <1323430372-5503-1-git-send-email-annie.li@oracle.com>	 <1323452339.20077.92.camel@zakaz.uk.xensource.com>	 <4EE57204.4030509@oracle.com> <1323673833.20936.65.camel@dagon.hellion.org.uk>
In-Reply-To: <1323673833.20936.65.camel@dagon.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EE5AE02.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-12 15:10, Ian Campbell wrote:
> On Mon, 2011-12-12 at 03:16 +0000, ANNIE LI wrote:
>>> Please can you name the arguments here and then refer to them by name in
>>> the comments instead of all this "First parameter", "second one" stuff.
>>>
>>> Similarly for the existing comments sorry I didn't notice this in
>>> previous review.
>> Please check following comments in gnttab_ops, I changed the "First
>> parameter", "second one" into parameter name. However, it looks not very
>> consistent with parameters format of function fn since only parameter
>> type exists, not name.
> You can give the parameters names in the function pointers too, that's
> what I was suggesting.
>
> e.g.:
>           int (*map_frames)(unsigned long *frames, unsigned int nr);
>
Ok, I will correct comments and add parameter names of existing function 
in a third patch.
Sub-page and trans patches should contain corrected comments and 
parameter names directly.

Thanks
Annie
> Ian.
>
