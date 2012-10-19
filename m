Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab2JSR7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:59:51 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:64420 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065Ab2JSR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:59:47 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/3] kconfig: add a function to get the CONFIG_ prefix
Date: Fri, 19 Oct 2012 19:59:40 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr> <1350589816-20447-3-git-send-email-yann.morin.1998@free.fr> <5081875D.90105@suse.cz>
In-Reply-To: <5081875D.90105@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201210191959.40851.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Friday 19 October 2012 Michal Marek wrote:
> On 18.10.2012 21:50, Yann E. MORIN wrote:
> > -#ifndef CONFIG_
> > -#define CONFIG_ "CONFIG_"
> > +/* Those two defines copied from include/linux/stringify.h */
> > +#define __stringify_1(x...)	#x
> > +#define __stringify(x...)	__stringify_1(x)
> > +static inline const char *CONFIG_prefix(void)
> > +{
> > +	return __stringify(CONFIG_);
> 
> This changes the semantics of the CONFIG_ macro. Previously, a
> double-quoted string was accepted, now you have to define it to a token
> that is turned into a string. Why don't you keep it as before and just do a
> 
> return CONFIG_;
> 
> in the function?

Yes, that's as simple as it looks, indeed. /me hides.

Thank you!
Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
