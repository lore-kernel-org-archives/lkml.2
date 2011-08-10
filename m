Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1HJCEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:04:05 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:52500 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1HJCEE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110810020157.GA29494@anthem.async.com.br>
References: <1312940007-26069-1-git-send-email-mturquette@ti.com>
 <1312940007-26069-2-git-send-email-mturquette@ti.com> <20110810020157.GA29494@anthem.async.com.br>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 9 Aug 2011 19:03:42 -0700
Message-ID: <CAJOA=zPb4Nt_vJ+oTkTpj7T2kuQPV+_wUdBhsE1tty+goW50jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpumask: introduce cpumask for hotpluggable CPUs
To: Christian Robottom Reis <kiko@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 7:01 PM, Christian Robottom Reis <kiko@linaro.org> wrote:
> On Tue, Aug 09, 2011 at 06:33:26PM -0700, Mike Turquette wrote:
>> - *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>> - *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
>> - *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
>> - *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
>> + *     cpu_possible_mask     - has bit 'cpu' set iff cpu is populatable
>> + *     cpu_hotpluggable_mask - has bit 'cpu' set iff cpu is hotpluggable
>> + *     cpu_present_mask      - has bit 'cpu' set iff cpu is populated
>> + *     cpu_online_mask       - has bit 'cpu' set iff cpu available to scheduler
>> + *     cpu_active_mask       - has bit 'cpu' set iff cpu available to migration
>
> Why not fix the 'iff' typo while you're here?

iff = if and only if

http://en.wikipedia.org/wiki/If_and_only_if

Thanks!
Mike

> Christian Robottom Reis, Engineering VP
> Brazil (GMT-3) | [+55] 16 9112 6430 | [+1] 612 216 4935
> Linaro.org: Open Source Software for ARM SoCs
>
