Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1LIFTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:19:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21569 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1LIFTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:19:41 -0500
Message-ID: <4EE19A4D.9030500@oracle.com>
Date: Fri, 09 Dec 2011 13:19:09 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com> <1323337048-5426-1-git-send-email-annie.li@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net> <4EE08B0D.80504@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EE19A69.0064,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

>>> #define get_free_entry()	get_free_entries(1)
Is this necessary? Maybe you defined this to keep consistence with 
put_free_entry(ref)?
But other functions such as gnttab_grant_foreign_transfer and 
gnttab_grant_foreign_access all call get_free_entries(1). Maybe it is 
better to keep initial get_free_entries(1) code?

Thanks
Annie
