Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab2CVVQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:16:05 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49468 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949Ab2CVVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:16:01 -0400
Date: Thu, 22 Mar 2012 22:15:57 +0100
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] tools: Add Makefile.lib
Message-ID: <20120322211557.GB1462@aftab>
References: <1332435713-32143-1-git-send-email-bp@amd64.org>
 <1332435713-32143-2-git-send-email-bp@amd64.org>
 <20120322210732.GA21154@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322210732.GA21154@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 10:07:32PM +0100, Sam Ravnborg wrote:
> On Thu, Mar 22, 2012 at 06:01:52PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Put generic enough build settings which could be reused by other tools
> > into a common Makefile.lib file.
> 
> I assume that the reason to use the filename "Makefile.lib" is that
> scripts/Makefile.lib uses the same extension.

Yep.

> But whoever idiot(*) that decided to use that extension deserve to be shot!

Ye^W^W.. oops, oh no, please no! :-)

> It is not a library per see, it is just a bunch of stuff you include
> in another makefile.
> So Makefile.include would be better - and as an added benefit vim
> does not barf on it.

Makes sense, will do, thanks.

> (*) I actually shave him quite often...

LOL.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
