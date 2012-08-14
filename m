Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2HNK2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:28:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8882 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2HNK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:28:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 14 Aug 2012 03:22:34 -0700
Message-ID: <502A243F.6050904@nvidia.com>
Date: Tue, 14 Aug 2012 15:41:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: "regulator: Enable supply regulator if child rail is enabled"
 broken?
References: <CAH+eYFAJ0FSiZoDiyYJsEg1j-cAhG7DkCwFNJGe5vBNpiUM7ug@mail.gmail.com> <502A11A0.7070906@nvidia.com> <CAH+eYFAu7kM7TSTd=WeoXz_NSUWGY5EmFwcb7a-p1kh_Lxrifw@mail.gmail.com>
In-Reply-To: <CAH+eYFAu7kM7TSTd=WeoXz_NSUWGY5EmFwcb7a-p1kh_Lxrifw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 02:45 PM, Rabin Vincent wrote:
> 2012/8/14 Laxman Dewangan<ldewangan@nvidia.com>:
>> Yaah, It is missing the regulator_disable() in regulator_init_complete() for
>> some cases.
>> Please let me know if I need to send patch for fixing this issue.
> Yes, please do.
I sent a patch. Please confirm whether this resolves the issue addressed 
by you or not.
