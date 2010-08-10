Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0HJTnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:43:42 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:27714 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HJTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:43:39 -0400
Message-ID: <4C61ABEA.9090104@tilera.com>
Date: Tue, 10 Aug 2010 15:43:38 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT] writable_limits for 2.6.36
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com> 	<4C617C94.5010808@tilera.com> <201008102050.12558.arnd@arndb.de> <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com>
In-Reply-To: <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2010 3:12 PM, Linus Torvalds wrote:
> On Tue, Aug 10, 2010 at 11:50 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>   
>> Right. The writable_rlimits syscall should just go after wait4 at 262.
>>     
> .. and in the meantime I added the notify tree too, so now the
> x86(-64) numbers also clashed.
>
> So I just moved the prlimit64() system call, both on x86[-64] and in
> asm-generic/unistd.h
>
> Pushed out. Guys, please verify that it looks ok.
>   

It looks good in asm-generic/unistd.h; thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

