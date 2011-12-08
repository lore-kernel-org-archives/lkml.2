Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1LHNra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:47:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49589 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1LHNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:47:29 -0500
Message-ID: <4EE0BFCA.7010208@oracle.com>
Date: Thu, 08 Dec 2011 21:46:50 +0800
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
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4EE0BFED.00CF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
> I say let's be optimistic :-) Yes, there's more overhead in the failure case, but that's not what we should be optimising for.
>   
>From positive side, it is OK. I agree with you since the failure case does not occurs frequently, the other goodness is the code style can keep identical with gnttab_grant_foreign_access and gnttab_grant_foreign_access_ref. thanks.

Thanks
Annie

