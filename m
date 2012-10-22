Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2JVKHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:07:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58884 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2JVKHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:07:22 -0400
Date: Mon, 22 Oct 2012 12:07:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121022100719.GA8352@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
 <20121020111625.GB17563@liondog.tnic>
 <87mwzfj7dn.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87mwzfj7dn.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 04:25:24PM +0900, Namhyung Kim wrote:
> It will add additional dependencies of asciidoc, docbook-xsl and/or
> something to default perf install command. I don't know it matters
> much, but just wanted to say. What if a user want to install the perf
> but the required packages for documents are not installed?

Ok, this is a valid point, more or less.

What we could do is leave the reference to "man perf-list" in perf list
output and *not* build install-man unconditionally. This way, people
who want to see the manpage, will need to install required packages. On
distros the manpage is already present so all is taken care of.

This way, we avoid the text duplication of adding this to perf --help.

-- 
Regards/Gruss,
    Boris.
