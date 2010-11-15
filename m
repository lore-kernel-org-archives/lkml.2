Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0KOJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:40:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab0KOJkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:40:37 -0500
Message-ID: <4CE0F713.8090503@redhat.com>
Date: Mon, 15 Nov 2010 11:02:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Arnd Bergmann <arnd@arndb.de>, autofs@linux.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: autofs4 hang in 2.6.37-rc1
References: <4CDFDC2B.6040205@redhat.com> <4CDFE948.4020709@redhat.com>	 <201011141615.32166.arnd@arndb.de> <1289784674.3248.11.camel@localhost>
In-Reply-To: <1289784674.3248.11.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 03:31 AM, Ian Kent wrote:
> >
> >  If the ioctl can sleep for multiple seconds, the mutex should
> >  indeed be dropped, and that would be safe because we used to
> >  do the same with the BKL.
> >
> >  The question is why this would sleep for more than 120 seconds.
>
> umount against a server that isn't responding can easily take more than
> 2 minutes.

Well, in my setup, the server should be responding.

-- 
error compiling committee.c: too many arguments to function

