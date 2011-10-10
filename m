Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865Ab1JJPHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:07:53 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:57217 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1JJPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:07:53 -0400
Message-ID: <4E930A3F.4060907@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 12:07:43 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: a.miskiewicz@gmail.com, m.selhorst@sirrix.com,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [tpmdd-devel] [PATCH] Refuse activation of tpm_tis driver if
 TPM is not working correctly
References: <1318249005.5482.5.camel@d941e-10> <4E92ED60.8080909@linux.vnet.ibm.com>
In-Reply-To: <4E92ED60.8080909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/11 10:04, Rajiv Andrade wrote:
> On 10/10/11 09:16, Stefan Berger wrote:
>> Refuse activation of tpm_tis driver if the TPM is found not to be
>> working correctly. This prevents suspend/resume problems for me on
>> Lenovo W500 and T61p.
>>
>> Signed-off-by: Stefan Berger<stefanb@linux.vnet.ibm.com>
> Testing and trying to reproduce it here.
Yes, for some yet unknown reason the TPM doesn't respond after a 
suspend/resume in case
it wasn't loaded before that. With this change/check, suspends work fine 
in this scenario
for me as well. Applied to:

github.com/srajiv/tpm.git next-tpm-fixes

Thanks for the fix Stefan.
Rajiv
