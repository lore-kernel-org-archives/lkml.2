Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab0FKWTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:19:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:44831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0FKWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:19:52 -0400
Message-ID: <4C12B685.30101@suse.cz>
Date: Sat, 12 Jun 2010 00:19:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 1/6]scripts:conf.c Fix warning: variable 'type' set but
 not used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com> <1276288869-16815-2-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276288869-16815-2-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.6.2010 22:41, Justin P. Mattock wrote:
> Not sure if this is correct or not, but with 
> make menuconfig
>   HOSTCC  scripts/kconfig/conf.o
> scripts/kconfig/conf.c: In function 'conf_sym':
> scripts/kconfig/conf.c:159:6: warning: variable 'type' set but not used
> scripts/kconfig/conf.c: In function 'conf_choice':
> scripts/kconfig/conf.c:231:6: warning: variable 'type' set but not used
>   HOSTLD  scripts/kconfig/mconf
> 
> I get this using gcc 4.6.0 the below change fixes this form me.
> please have a look and let me know.
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Thanks, applied.

Michal
