Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1HBT0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:26:19 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63092 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab1HBT0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:26:13 -0400
Date: Tue, 2 Aug 2011 21:26:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        xiyou.wangcong@gmail.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and
	IS_MODULE()
Message-ID: <20110802192610.GA5338@merkur.ravnborg.org>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz> <1311947497-4958-1-git-send-email-mmarek@suse.cz> <20110802173343.GA5251@merkur.ravnborg.org> <CACqU3MUy_EBaVB_VHW0EcbMcV9Qn_H=oh4ZKkCaUuPtbezpC4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MUy_EBaVB_VHW0EcbMcV9Qn_H=oh4ZKkCaUuPtbezpC4A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > If we do it like this then how about adding this to autoconf.h and avoid the extra file,
> > and the extra flag to gcc?
> >
> That would be intrusive for non-Linux users of kconfig. You would have
> to hardcode a <linux/kconfig.h> in autoconf.h, which mean other
> project would have to either mirror the Linux include tree structure,
> or modify kconfig for the desired include path, if the feature is
> desired at all. As I see it, Linux, through Kbuild, is a user of
> kconfig.
The idea was to entirely skip kconfig.h - and include the code in
autoconf.h verbatim - so no extra file.

We could add an option to disable this - if the other kconfig
really require this.

	Sam
