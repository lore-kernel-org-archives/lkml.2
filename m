Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab2C3QPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:15:39 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45171 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934536Ab2C3QPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:15:33 -0400
Date: Fri, 30 Mar 2012 18:15:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120330161526.GE30876@aftab>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
 <20120330052605.GA30508@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330052605.GA30508@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 07:26:05AM +0200, Sam Ravnborg wrote:
> > $ make tools/<toolname> tinstall
> But this makes no sense.
> 
> It would be better to be consistent - so the user does not need to remember
> when to add a space and when not.
> 
> make tools/<command> where <command> is one of help, install, clean, "nothing"
> make tools/<toolname>
> make tools/<toolname>_<comand> where command is the same set of commands
> 
> 
> then a user could do:
> 
>     make tools/clean
>     make tools/perf
>     make tools/perf_install
> 
> or
> 
>     make tools/clean
>     make tools/
>     make tools/install

This one I had hard time imagining: who would install all tools but I
guess it could have it's use...

> The install target could implicitly include the build target.
> 
> With this scheme the user is up to less suprises.
> 
> All the above are only minor adjustments compared to what you already did.
> bt the consistency here is a gain (IMO).

... but yeah, those make sense to me too, let's see what the others
think, Arnaldo, Ingo?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
