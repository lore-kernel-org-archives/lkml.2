Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0ESUFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:05:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60116 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002Ab0ESUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:05:34 -0400
Message-ID: <4BF4445F.9040104@zytor.com>
Date: Wed, 19 May 2010 13:04:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Autofs <autofs@linux.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 2/8] autofs: Pushdown the bkl from ioctl
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com> <1274289855-10001-3-git-send-regression-fweisbec@gmail.com> <4BF4279C.2000805@zytor.com> <20100519180832.GA9752@nowhere> <4BF42A5E.6060503@zytor.com> <20100519190307.GC9752@nowhere>
In-Reply-To: <20100519190307.GC9752@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 12:03 PM, Frederic Weisbecker wrote:
>>
>> But it's not ... it is locked at that point.  It's not lock*ing*, but it
>> is not *unlocked*, either.  Furthermore, it is directly contradicting
>> the naming scheme of the ops structure.
>>
> 
> Would you prefer me to resend a patch?
> 

Yes, that would be my preference.

We really need to set a date to kill off autofs3 completely -- I don't
care if we rename anything or not -- and add it to feature-removal.txt.

	-hpa
