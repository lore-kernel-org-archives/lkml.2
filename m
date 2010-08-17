Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0HQQA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:00:56 -0400
Received: from xenotime.net ([72.52.115.56]:33321 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757730Ab0HQQAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:00:54 -0400
Date: Tue, 17 Aug 2010 09:00:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sergey Naumov <sknaumov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: bug LINUX_VERSION_CODE undefined
Message-Id: <20100817090044.d4026453.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimC=VDH=m9SoDK3BGzk7eCKRj6dEVzU230_kFPH@mail.gmail.com>
References: <AANLkTik2VDPSZvMzQ8rv38jBDKmRaM9-TL9nhqxj_VSQ@mail.gmail.com>
	<AANLkTimC=VDH=m9SoDK3BGzk7eCKRj6dEVzU230_kFPH@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 13:29:38 +0400 Sergey Naumov wrote:

> Hello. This is my first message to this list so please be patient.
> 
> I have encountered compilation error due to
> #define LINUX_VERSION_CODE
> in include/linux/version.h
> 
> This happens because $(VERSION) variable in the main Makefile has a
> value of 2.6.35.2 instead of 2,
> so "expr" utility fails to generate LINUX_VERSION_CODE value with an
> error "non-numeric argument" or smth.

AFAIK, it usually happens due to some shell not liking some syntax in the Makefile.
What shell are you using?


> I have found only one link (
> http://www.spinics.net/lists/linux-kbuild/msg03230.html ) to this
> issue in the Internet,
> but there is no response to it, so I decided to post this message.

There are replies in the bugzilla entry, including a possible fix.
  https://bugzilla.kernel.org/show_bug.cgi?id=16510


> Please subscribe me personally to answers to this post.

Michal, did you do anything with your suggested fix?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
