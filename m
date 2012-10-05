Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2JEM1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:27:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:47188 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab2JEM1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:27:54 -0400
Date: Fri, 5 Oct 2012 14:27:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121005122741.GB8019@aftab.osrc.amd.com>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506EC1AE.6000201@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 01:17:02PM +0200, Jiri Slaby wrote:
> BTW what scares me that nobody noticed that bug until this is in the
> Linus's tree. Do people use -next at all or am I the only one user? (I
> didn't hit it as I have the patch in my local queue.)

Noticing this before -rc1 and fixing it around that time is still fine
in my book. So can *someone* *please* send a patch already so that we
can forget about this.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
