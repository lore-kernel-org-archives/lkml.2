Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0I3UVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:21:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53928 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab0I3UVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:21:54 -0400
Message-ID: <4CA4F10E.5060109@zytor.com>
Date: Thu, 30 Sep 2010 13:20:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TcOhcnRvbiBOw6ltZXRo?= <nm127@freemail.hu>,
        Arnd Bergmann <arnd@arndb.de>, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT
 is defined
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com> <AANLkTinnRB-cpRrxymUQYMx0TjgkDkSbg=Euaq+Y16sE@mail.gmail.com>
In-Reply-To: <AANLkTinnRB-cpRrxymUQYMx0TjgkDkSbg=Euaq+Y16sE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 01:00 PM, Geert Uytterhoeven wrote:
> 
> An alternative (and IMHO better) fix would be to move autofs_root_operations[]
> and autofs_root_inode_operations[] to the bottom of the file, and get rid of all
> the forward declarations.
> 

This is a legacy piece of code (autofs3) which has been long since
obsolete anyway... it's one thing to do a minimal patch to keep it
alive, another to restructure crap when it's already overdue for removal.
	
	-hpa
