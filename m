Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0GETnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:43:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58742 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0GETnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:43:24 -0400
Message-ID: <4C3235C3.7050303@zytor.com>
Date: Mon, 05 Jul 2010 12:42:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-4-git-send-email-arnd@arndb.de> <20100705192358.GC5240@nowhere>
In-Reply-To: <20100705192358.GC5240@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
> On Sun, Jul 04, 2010 at 12:15:07AM +0200, Arnd Bergmann wrote:
>> Handling of autofs ioctl numbers does not need to be generic
>> and can easily be done directly in autofs itself.
>>
>> This also pushes the BKL into autofs and autofs4 ioctl
>> methods.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: H. Peter Anvin <hpa@zytor.com>
> 
> Peter, if you're fine with this version. May I apply it?
> Unless you have a tree for autofs.
> 
> Thanks.

Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
through him (or acked by him.)

autofs 3 is officially unmaintained; I'm more than happy to have you
push the autofs 3 bits of this patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

