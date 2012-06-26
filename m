Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2FZKlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:41:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2FZKlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:41:00 -0400
Message-ID: <4FE991B8.2080706@suse.cz>
Date: Tue, 26 Jun 2012 12:40:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH 8/8] kbuild: remove useless warning
References: <20120505080640.GA13773@merkur.ravnborg.org> <1336205926-13946-8-git-send-email-sam@ravnborg.org>
In-Reply-To: <1336205926-13946-8-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.5.2012 10:18, Sam Ravnborg wrote:
>  ifneq ($(KCPPFLAGS),)
> -        $(call warn-assign,CPPFLAGS)
>          KBUILD_CPPFLAGS += $(KCPPFLAGS)
>  endif
>  ifneq ($(KAFLAGS),)
> -        $(call warn-assign,AFLAGS)
>          KBUILD_AFLAGS += $(KAFLAGS)
>  endif
>  ifneq ($(KCFLAGS),)
> -        $(call warn-assign,CFLAGS)
>          KBUILD_CFLAGS += $(KCFLAGS)
>  endif

The tests for non-empty can be dropped now.

Michal

