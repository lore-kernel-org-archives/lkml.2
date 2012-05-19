Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2ESRpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:45:43 -0400
Received: from sif.is.scarlet.be ([193.74.71.28]:33115 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2ESRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:45:41 -0400
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2012 13:45:40 EDT
X-Scarlet: u=tsg45800 d=1337448528 c=83.134.21.164
Message-ID: <4FB7F46F.9000708@scarlet.be>
Date: Sat, 19 May 2012 21:28:47 +0200
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Joe Perches <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] hp100: delete VG/AnyLAN hp100
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com> <1337272841-25931-3-git-send-email-paul.gortmaker@windriver.com> <4FB52C99.6010303@windriver.com> <20120517212039.GC27789@windriver.com> <1337292547.8872.20.camel@joe2Laptop> <20120517222843.GA30680@electric-eye.fr.zoreil.com>
In-Reply-To: <20120517222843.GA30680@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: sif 20001; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe, et al,

Effectively, I was using a hp100 but this system is retired since 2 years now (but I keep it just in case of major failure 
of the new box).

Cheers,
	J.

On 05/18/2012 12:28 AM, Francois Romieu wrote:
> Joe Perches<joe@perches.com>  :
>> On Thu, 2012-05-17 at 17:20 -0400, Paul Gortmaker wrote:
>>> [Re: [PATCH 2/5] drivers/net: delete all code/drivers depending on CONFIG_MCA
>>
>> If we're removing really old and unused stuff,
>> how about the VG/AnyLAN driver too?
>
> Joel Soete appeared to actively use a PCI one with recent kernels back
> in 2007.
>
