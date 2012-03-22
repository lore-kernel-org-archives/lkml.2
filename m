Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2CVVHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:07:36 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:28038 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2CVVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:07:35 -0400
Date: Thu, 22 Mar 2012 22:07:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] tools: Add Makefile.lib
Message-ID: <20120322210732.GA21154@merkur.ravnborg.org>
References: <1332435713-32143-1-git-send-email-bp@amd64.org> <1332435713-32143-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332435713-32143-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 06:01:52PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Put generic enough build settings which could be reused by other tools
> into a common Makefile.lib file.

I assume that the reason to use the filename "Makefile.lib" is that
scripts/Makefile.lib uses the same extension.

But whoever idiot(*) that decided to use that extension deserve to be shot!
It is not a library per see, it is just a bunch of stuff you include
in another makefile.
So Makefile.include would be better - and as an added benefit vim
does not barf on it.

(*) I actually shave him quite often...

	Sam
