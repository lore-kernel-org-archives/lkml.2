Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1KNWAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:00:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960Ab1KNWAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:00:04 -0500
Message-ID: <4EC18F5E.2040407@zytor.com>
Date: Mon, 14 Nov 2011 13:59:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid memory
 addresses.
References: <2018804336.46235.1321305700330.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <2018804336.46235.1321305700330.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 01:21 PM, Andrei Warkentin wrote:
>
> I know you're very busy, but I was wondering if you could
> give your two cents on this change. This change grew from
> our discussion on LKML last week.
>
> Thanks ahead,
> A

EOF seems wrong to me (not as bad as EFAULT, but still wrong).

	-hpa
