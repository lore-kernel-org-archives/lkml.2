Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1KJB5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:57:12 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:39659 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1KJB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:57:10 -0500
Message-ID: <4EBB2F68.8070609@oracle.com>
Date: Thu, 10 Nov 2011 09:56:56 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] RE: [PATCH 1/3] Introducing grant table V2 stucture
References: <4EBA35D3.3020506@oracle.com>	<1320826490-29362-1-git-send-email-annie.li@oracle.com>	<291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>	<20111109144922.GC8410@phenom.dumpdata.com>	<291EDFCB1E9E224A99088639C4762022B4543AB204@LONPMAILBOX01.citrite.net>	<4EBAA3B1.8010401@oracle.com> <1320855724.955.183.camel@zakaz.uk.xensource.com>
In-Reply-To: <1320855724.955.183.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EBB2F73.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-10 0:22, Ian Campbell wrote:
> IMHO the gnttab_ bit belongs in either (or both) the struct name or the
> variable names referencing the struct, rather than the fields
> themselves. It should be obvious from the context that this member is
> something to do with gnttab. e.g. I think gnttab_shared->addr would be
> fine, as would shared->addr in the context of gnttab.c etc.
Right.
Thanks you all for the review, I will improve patches based on those 
suggestions and resend them.

Thanks
Annie
