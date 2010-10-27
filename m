Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0J0Rfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0J0Rfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:35:42 -0400
Message-ID: <4CC863D6.7010404@redhat.com>
Date: Wed, 27 Oct 2010 19:39:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com>
In-Reply-To: <4CC8380D.3040802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
> Linus,
>
> Please pull from
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>

<snip snip>

I see that you did not include the changes from my pull request send today,
understandably so, but I wonder if these could still get into 2.6.37 for say
rc2 ?

All of them are bug fixes except for the xirlink_cit button support which
makes changes to a driver new this cycle, so no chance for causing regressions
there.

Regards,

Hans
