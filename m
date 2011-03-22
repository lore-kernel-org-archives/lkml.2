Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1CVNQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:16:45 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:38039 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1CVNQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:16:43 -0400
Message-ID: <4D88A12D.60301@linux.vnet.ibm.com>
Date: Tue, 22 Mar 2011 10:16:29 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Huewe <huewe.external.infineon@googlemail.com>
CC: James Morris <jmorris@namei.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] TPM driver robustness fixes
References: <4D81708D.5090607@linux.vnet.ibm.com> <alpine.LRH.2.00.1103220956350.14837@tundra.namei.org> <AANLkTimS1ss=977x3d-7Wcpj0wGthzW3_G+wqF1wQMc3@mail.gmail.com> <AANLkTi=uZME7Pr761VJkEiJYFp7L3iexjV3JeMmL63it@mail.gmail.com>
In-Reply-To: <AANLkTi=uZME7Pr761VJkEiJYFp7L3iexjV3JeMmL63it@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11032213-9254-0000-0000-0000012B9A7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 09:58 AM, Peter Huewe wrote:
>
>> Consider what happens in memset if copy_to_user fails.
> Sorry I don't see it. Can you please clearify the problem for me?
>
memset() is called with the count parameter being a negative value,
ret_size=-EFAULT.

Rajiv

