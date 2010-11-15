Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0KON1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:27:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab0KON1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:27:32 -0500
Message-ID: <4CE13539.1020106@redhat.com>
Date: Mon, 15 Nov 2010 15:27:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Arnd Bergmann <arnd@arndb.de>, autofs@linux.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: autofs4 hang in 2.6.37-rc1
References: <4CDFDC2B.6040205@redhat.com> <4CE00194.3070601@redhat.com>	 <1289785533.3248.18.camel@localhost>  <201011150954.34289.arnd@arndb.de> <1289827341.3248.49.camel@localhost>
In-Reply-To: <1289827341.3248.49.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 03:22 PM, Ian Kent wrote:
> >  Ian, if you can prove that the lock is not needed, I think we shold
> >  just remove it.
>
> I don't think I can prove it but I will have a long look at the code.
> I don't think it is needed and I expect I'll recommend it be removed.

I've been running with the lock removed for a while with no ill effect.  
Of course it doesn't prove anything but at least it's a workaround for me.

-- 
error compiling committee.c: too many arguments to function

