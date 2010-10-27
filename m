Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0J0Rw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0J0Rw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:52:26 -0400
Message-ID: <4CC866C9.2010803@redhat.com>
Date: Wed, 27 Oct 2010 15:52:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC863D6.7010404@redhat.com>
In-Reply-To: <4CC863D6.7010404@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 15:39, Hans de Goede escreveu:
> Hi,
> 
> On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
>> Linus,
>>
>> Please pull from
>>     ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>>
> 
> <snip snip>
> 
> I see that you did not include the changes from my pull request send today,
> understandably so, but I wonder if these could still get into 2.6.37 for say
> rc2 ?
>
> All of them are bug fixes except for the xirlink_cit button support which
> makes changes to a driver new this cycle, so no chance for causing regressions
> there.

Before posting patches upstream, I send them to Linux-next in order to be tested there 
for a while, before sending pull requests upstream. So, yes, patches sent me recently
will need to wait for the next series of patches.

I can't tell you in advance if I'll merge them for rc2, as I didn't review them yet,
and I'll be travelling abroad next week for LPC/KS, but bug fixes need to be addressed 
and merged in time for 2.6.37.

Cheers,
Mauro.
