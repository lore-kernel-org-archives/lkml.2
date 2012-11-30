Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031560Ab2K3SrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:47:17 -0500
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:44044 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030923Ab2K3SrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:47:15 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IPNQIYMVM1kOPIoSzNUVoBvQYhKJ3aYjzG9eMnZKCt2iO7A
 LAz3ripGjChkhUl6D1mqVCqj__PUuSeEPVtaijNfM5RdqqAtmpdDbD7KmvM.
 yN13Q1d1pBnZzlftyHezzDFZs6zkQmgXCetsSR8knneEUFIkeQMq_366Myv4
 sLoOjEYvVYAmZokL1EnlTrgqTtV4sXEj51cqKf5.8FC3X9EEaI0d.3gLKYwi
 Fx7aH1fhTFwHxbV.Jmhmzpf9_wSrCpNfo4WkK_FpxEsa8rSAuUcTkxuC1IRO
 8qXxFYVRMAezHenkOtBXhy13DKJ1FMjNxFMhri5.47AvEqW8DmXQ8JBsrFp0
 Enw1t980cx0cqmQ0WLMERuTyT0S1_rRH0uHwSNP8ieJT8p0hvp3XiF0vn5I.
 dNDJ6op2XRrQoHk.yJ0RiJgs.cpNFU_L125xJZqjycbtiAy9a7FWVbQ8VuOK
 9t3gclVBMf2OX81YVSuMX7QnFXLrpBcP7DvPIABpq8wRC5d1GSWRQmQspHQ-
 -
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B8FF3B.80003@schaufler-ca.com>
Date: Fri, 30 Nov 2012 10:47:23 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rdunlap@xenotime.net, paul@paul-moore.com, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: Add missing depends on INET in Kconfig
References: <50B8E4E6.2040901@xenotime.net> <50B8ECB3.2090801@schaufler-ca.com> <50B8EF79.4080907@xenotime.net> <20121130.134326.730429492162984746.davem@davemloft.net>
In-Reply-To: <20121130.134326.730429492162984746.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 10:43 AM, David Miller wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: Fri, 30 Nov 2012 09:40:09 -0800
>
>> On 11/30/2012 09:28 AM, Casey Schaufler wrote:
>>
>>> Because NETLABEL depends on INET SECURITY_SMACK
>>> has to explicitly call out the dependency.
>>>
>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Thanks for the quick fix.
> In what tree does this Kconfig file look like this?

James Morris' security-next

>
> In my net-next tree the current dependencies are expressed as:
>
> 	depends on NETLABEL && SECURITY_NETWORK
>

