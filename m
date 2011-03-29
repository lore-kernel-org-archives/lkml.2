Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1C2POf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:14:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50227 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1C2POf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:14:35 -0400
Message-ID: <4D91F754.6010503@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:14:28 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com, preining@logic.at
Subject: Re: [patch 2/8] tpm_tis: Re-enable interrupts upon (S3) resume
References: <20110315111307.895085413@linux.vnet.ibm.com> <20110315111425.977309317@linux.vnet.ibm.com> <4D91EE8D.1010305@linux.vnet.ibm.com>
In-Reply-To: <4D91EE8D.1010305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:37 AM, Rajiv Andrade wrote:
> On 03/15/2011 08:13 AM, Stefan Berger wrote:
>> v2:
>>    - the patch was adapted to also work with a machine with a Intel iTPM
>>
> This is also a separated fix, which this time I can't also identify
> in the patch, can you submit it as another patch, that applies
> on top of the original 2/8?
There are two types of drivers in the tpm_tis driver, the pnp one and 
the 'platform' driver. The initial patch did not provide support for 
both of them, so maybe the comment above is misleading. I'll fix the 
comment, but don't think it makes sense tearing the patch into two pieces.

    Stefan

> Rajiv

