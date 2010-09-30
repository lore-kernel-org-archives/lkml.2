Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0I3J4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:56:05 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:44907 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab0I3J4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:56:04 -0400
Message-ID: <4CA45EB0.30002@xyzw.org>
Date: Thu, 30 Sep 2010 02:56:00 -0700
From: Brian Rogers <brian@xyzw.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.36] V4L/DVB fixes
References: <4CA10545.4010204@redhat.com> <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com> <4CA13893.8050409@redhat.com>
In-Reply-To: <4CA13893.8050409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 05:36 PM, Mauro Carvalho Chehab wrote:
> I'll clean up the mess and prepare a new pull request in the next days.

Can you look at including "ir-core: Fix null dereferences in the 
protocols sysfs interface"? I never got a response to that, and it's a 
regression fix for 2.6.36.

https://patchwork.kernel.org/patch/199002/

