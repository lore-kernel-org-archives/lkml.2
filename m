Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2DTOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:48:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:54544 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2DTOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:48:45 -0400
Message-ID: <4F917751.9040600@parallels.com>
Date: Fri, 20 Apr 2012 18:48:49 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 07:43 PM, Dave Kleikamp wrote:
> From: Zach Brown<zab@zabbo.net>
>
> This uses the new kernel aio interface to process loopback IO by
> submitting concurrent direct aio.  Previously loop's IO was serialized
> by synchronous processing in a thread.
>

The patch ignores REQ_FLUSH bit of bi_rw. Is it simply overlook?

Thanks,
Maxim
