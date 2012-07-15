Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2GOKML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:12:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34214 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOKMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:12:06 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <4FF335E3.5040509@codeaurora.org>
References: <1341259857-17382-1-git-send-email-ohad@wizery.com> <4FF335E3.5040509@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 13:11:46 +0300
Message-ID: <CAK=WgbZ7ZoVqniJzfXXvq1krUWanteB73J=28GstnFmpWGHfvw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: remove the get_by_name/put API
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Michal Simek <monstr@monstr.eu>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 9:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/02/12 13:10, Ohad Ben-Cohen wrote:
>> Remove rproc_get_by_name() and rproc_put(), and the associated
>> remoteproc infrastructure that supports it (i.e. klist and friends),
>> because:
>>
>> 1. No one uses them
>> 2. Using them is highly discouraged, and any potential user
>>    will be deeply scrutinized and encouraged to move.
>>
>> If a user, that absolutely can't live with the direct boot/shutdown
>> model, does show up one day, then bringing this functionality back
>> is going to be trivial.
>>
>> At this point though, keeping this functionality around is way too
>> much of a maintenance burden.
>>
>
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, applied.
