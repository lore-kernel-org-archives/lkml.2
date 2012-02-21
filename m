Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2BUFzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:55:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44383 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab2BUFzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:55:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.182.54.114 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4F432D7A.7030805@nvidia.com>
References: <1329799491.7033.1.camel@phoenix> <4F432D7A.7030805@nvidia.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 21 Feb 2012 13:55:27 +0800
Message-ID: <CAF+7xWk7PeJ5qDi+pA-+vgqBt0bdr1Ld=gTNh-DnkZpmooLOAw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Group TI TPSxxxxx regulators together
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/21 Laxman Dewangan <ldewangan@nvidia.com>:
> On Tuesday 21 February 2012 10:14 AM, Axel Lin wrote:
>>
>> Group TI TPSxxxxx regulators together and sort them in alphabetical order.
>> This change makes it easier for users to find config options.
>>
>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>> Cc: Mike Rapoport<mike@compulab.co.il>
>> Cc: Cyril Chemparathy<cyril@ti.com>
>> Cc: Graeme Gregory<gg@slimlogic.co.uk>
>> Cc: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>
> Should we only arrange the tps regulators or all regulators in alphabetical
> order?
> I will prefer to arrange all which inherently will arrange tps as all ti
> regulators start with tps..
I think it would be easier for review the patch if we can apply this one first,
then an incremental patch to arrange all other regulator drivers.
( Most other regulator drivers are already grouped by similar drivers).

Regards,
Axel
