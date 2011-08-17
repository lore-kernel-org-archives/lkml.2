Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HQNRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1HQNRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:17:35 -0400
Date: Wed, 17 Aug 2011 15:14:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
Message-ID: <20110817131444.GA13676@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-13-git-send-email-matt@console-pimps.org> <20110816172010.GC29190@redhat.com> <20110816172049.GD29190@redhat.com> <4E4BBB8D.5020307@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4BBB8D.5020307@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Michal Simek wrote:
>
> Oleg Nesterov wrote:
>> On 08/16, Oleg Nesterov wrote:
>>> This and the next patch seem to have the same problems with the
>>> changelogs as 18 and 19.
>>>
>>> 13-14 looks correct to me...
>>
>> I meant 14-15, sorry for noise
>
> Do you mean that there is
> From: Matt Fleming <matt.fleming@intel.com> ?

Confused... "From" looks correct to me.

The changelog is wrong and should be updated (Matt seems to agree).
This patch fixes the bug, this should be explained. The problem is,
ka points to the copy of sighand->action, the current code is pointless.

> Anyway: I have looked at patches 12-15 and they look good to me.
>
> Acked-by: Michal Simek <monstr@monstr.eu>

Assuming the changelog is fixed,

	Acked-by: Oleg Nesterov <oleg@redhat.com>

> If you want to propose 12-15 through my Microblaze tree, please let me know.

Probably this is the best option. Matt, what do you think?

Oleg.

