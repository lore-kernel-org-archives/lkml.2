Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2DNIVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:21:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab2DNIVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:21:31 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 10:21:28 +0200
User-Agent: KMail/1.9.10
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz> <201204140843.08671.l.lunak@suse.cz> <CA+55aFwCY0jkFGAzOP5SFb8THQts7BDb_ivChT7K6LvVn6OqoQ@mail.gmail.com>
In-Reply-To: <CA+55aFwCY0jkFGAzOP5SFb8THQts7BDb_ivChT7K6LvVn6OqoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204141021.28906.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 of April 2012, Linus Torvalds wrote:
> Yeah, I'm not a fan of C++. It's a cruddy language.

 Whatever. There's no need for you to waste time on lecturing me on C++, I 
know it well enough, including the pitfalls. And I especially know well about 
C++'s NULL, I got enough theoretical lectures from gcc people while making 
them not bury warnings about incorrect NULL usage in the rather 
useless -Wconversion. The reality is what it is regardless of how much you or 
I like it.

 How about the patch? Are there any *actual* problems with it or can it please 
go in?

-- 
 Lubos Lunak
 l.lunak@suse.cz
