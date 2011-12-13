Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1LMNRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:17:14 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:42323 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1LMNRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:17:12 -0500
X-Greylist: delayed 11025 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Dec 2011 08:17:11 EST
Message-ID: <4EE7504D.6040509@eukrea.com>
Date: Tue, 13 Dec 2011 14:17:01 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, festevam@gmail.com
Subject: Re: [PATCH 08/19] dma: MX3_IPU fix depends
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-8-git-send-email-eric@eukrea.com> <4EE72EAB.4040308@ru.mvista.com>
In-Reply-To: <4EE72EAB.4040308@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/12/2011 11:53, Sergei Shtylyov a écrit :
> On 13-12-2011 10:31, Eric Bénard wrote:
>
>> ARCH_MX3 was removed in e760b5260d39113794da17c64cbd6e6311155b66
>
> Please also specify that commit's summary in parens.
>
good point, especially I pointed to the wrong commit.
v2 follows including change addressing Fabio's comments

Eric
