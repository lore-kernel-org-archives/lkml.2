Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0E0WTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:19:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34571 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab0E0WTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:19:10 -0400
Message-ID: <4BFEEF89.3050107@zytor.com>
Date: Thu, 27 May 2010 15:17:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Lassabe <frederic.lassabe@gmail.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Subject: Re: [GIT PULL] Bkl ioctl pushdowns for 2.6.35-rc1
References: <1274547426-25937-1-git-send-regression-fweisbec@gmail.com> <201005272338.25049.arnd@arndb.de> <20100527220334.GC5390@nowhere>
In-Reply-To: <20100527220334.GC5390@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 03:03 PM, Frederic Weisbecker wrote:
> 
>> | fs/autofs/root.c
>>
>> A discussion came up on the naming of the function after
>> the patch, and another discussion on when to finally
>> kill this driver.
> 
> But I won't wait for the driver to be removed though, so I'll
> fix the naming issue and queue it soon.
> 

Thanks.  Assuming the obvious naming change:

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
