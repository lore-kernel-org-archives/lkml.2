Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780Ab0KRW3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:29:43 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:46485 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab0KRW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:29:42 -0500
Message-ID: <4CE5A8D2.5050104@mandriva.org>
Date: Fri, 19 Nov 2010 00:29:38 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Galbraith patch
References: <1290018947.4887.14.camel@note-311a> <4CE5731B.20807@mandriva.org> <1290110456.10702.12.camel@maggy.simson.net> <201011181628.13324.gene.heskett@gmail.com>
In-Reply-To: <201011181628.13324.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett skrev 18.11.2010 23:28:
> On Thursday, November 18, 2010, Mike Galbraith wrote:
>> On Thu, 2010-11-18 at 20:40 +0200, Thomas Backlund wrote:
>>> and more importantly it misses theese:
>> Heh.  Apply the attached, autogroup last.
>
> Still incomplete I'd guess.  From the make bzimage:
> In file included from kernel/sched.c:1931:
> kernel/sched_autogroup.c: In function ‘autogroup_create’:
> kernel/sched_autogroup.c:56: error: ‘struct task_group’ has no member named
> ‘autogroup’
>

Please recheck that you are using only the 2 patches Mike sent.
With them applied to Mandriva 2.6.36 kernel it built fine with
CONFIG_SCHED_AUTOGROUP=y

--
Thomas
