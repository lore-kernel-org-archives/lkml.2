Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1KQHm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:42:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1KQHmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:42:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YN19wnvKtExyvPrtrQQDp7fnJc0jWHx9oapADwtipaJDQ@mail.gmail.com>
References: <1318376345.2050.20.camel@boudreau>
	<j9r5m5$b18$1@dough.gmane.org>
	<1321296650.2066.17.camel@boudreau>
	<4EC21F67.10905@redhat.com>
	<1321396371.4198.5.camel@boudreau>
	<4EC31E55.6040809@redhat.com>
	<1321467647.2137.4.camel@boudreau>
	<4EC47FCA.5090908@redhat.com>
	<CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>
	<4EC491B3.705@redhat.com>
	<CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
	<4EC4B60C.3030706@redhat.com>
	<CAOS58YN19wnvKtExyvPrtrQQDp7fnJc0jWHx9oapADwtipaJDQ@mail.gmail.com>
Date: Thu, 17 Nov 2011 15:42:52 +0800
Message-ID: <CAM_iQpWB9P06LH6emP73oRVog4MGbHip=ofmPEVUy57uBK56GQ@mail.gmail.com>
Subject: Re: Crash during vmcore_init
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, Tim Hartrick <tim@edgecast.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 3:23 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Nov 16, 2011 at 11:21 PM, Dave Young <dyoung@redhat.com> wrote:
>>> I will be happy to answer any questions about our environment or test
>>> debug or other patches.  Just tell me what you need.
>>
>>
>> Thank you. Can you share your kernel config?
>
> Yes, please, I'm wondering whether PER_CPU_KM is in use.
>

Another interesting thing is that all of these per cpu addr's are same,
as Tim has 8 CPU's, probably he has CONFIG_SMP, so these addr's
should be different...
