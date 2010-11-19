Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab0KSA2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:28:14 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65132 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0KSA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:28:13 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Nori\, Sekhar" <nsekhar@ti.com>
Cc: Nicolas Kaiser <nikai@nikai.net>,
        "davinci-linux-open-source\@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mach-davinci: signedness bug
Organization: Deep Root Systems, LLC
References: <20101115194028.30f8b7f0@absol.kitzblitz>
	<B85A65D85D7EB246BE421B3FB0FBB5930234A2AF08@dbde02.ent.ti.com>
Date: Thu, 18 Nov 2010 16:28:08 -0800
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930234A2AF08@dbde02.ent.ti.com>
	(Sekhar Nori's message of "Tue, 16 Nov 2010 10:19:49 +0530")
Message-ID: <87lj4qduna.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nori, Sekhar" <nsekhar@ti.com> writes:

> Hi Nicolas,
>
> On Tue, Nov 16, 2010 at 00:10:28, Nicolas Kaiser wrote:
>> aemif_calc_rate() can return a negative error value, so all the
>> variables that get tested for this value need to be signed.
>>
>> The maximum bit width of WSETUP(WSETUP_MAX) appears to be 30 bits
>> (0xf << 26). Using a signed instead of an unsigned integer
>> shouldn't make a difference here.
>>
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
>
> Thanks for the fix. You could use the subject:
>
> "davinci: signedness bug in davinci_aemif_setup_timing()"
>
> Other than that:
>
> Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks, I fixed up the subject as Sekhar suggested.

Applied, queuing for 2.6.38.

Kevin

