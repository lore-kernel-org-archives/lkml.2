Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab2FDMrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2FDMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:47:22 -0400
Message-ID: <4FCCAE54.3010602@redhat.com>
Date: Mon, 04 Jun 2012 14:47:16 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John Moser <john.r.moser@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is this code right in zram?
References: <4FC7E610.5060207@gmail.com> <4FCCA543.3030603@redhat.com> <1338813236.8574.6.camel@joe2Laptop>
In-Reply-To: <1338813236.8574.6.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 02:33 PM, Joe Perches wrote:
> On Mon, 2012-06-04 at 14:08 +0200, Jerome Marchand wrote:
>> It probably doesn't matter much.
> 
> Likely true.
> 
>> Apparently kcalloc() never got  a lot
>> of success and kzalloc(sizeof(foo) * num_foos) type of allocation are
>> more popular.
> 
> Likely false, especially in new code.
> 
> If you did greps, perhaps you are including the
> 	k.alloc(sizeof(*foo), GFP)
> forms in your uses multiply counts.

No. Actually I greped it and look quickly at which proportion of those
kzalloc() looked like the above. I have to admit that my sample was
small and certainly not evenly distributed around the source tree.

Jerome

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

