Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1KVKCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:02:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61879 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1KVKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:02:19 -0500
Message-ID: <4ECB7324.9080008@oracle.com>
Date: Tue, 22 Nov 2011 18:02:12 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 3/4] xen/granttable: Grant tables V2 implementation
References: <4ECA416D.90602@oracle.com>	 <1321927161-3987-1-git-send-email-annie.li@oracle.com> <1321954186.3664.403.camel@zakaz.uk.xensource.com>
In-Reply-To: <1321954186.3664.403.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ECB7327.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-22 17:29, Ian Campbell wrote:
> On Tue, 2011-11-22 at 01:59 +0000, annie.li@oracle.com wrote:
> [...]
>> +#ifdef CONFIG_X86
>> +		barrier();
>> +#else
>> +		mb();
>> +#endif
>> +		}
> Niggle: Indentation of this final } is off.
Sorry, I did not notice that.
> Otherwise all 4 patches:
> Acked-by: Ian Campbell<ian.campbell@citrix.com>
>
> [...]
Thanks, I will resend those patches after above indentation issue is fixed.

Thanks.

Thanks
Annie
