Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab2DKTrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:47:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45201 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761010Ab2DKTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:47:42 -0400
Date: Wed, 11 Apr 2012 21:47:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120411194730.GB18114@aftab>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411180434.GH16257@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 03:04:34PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Apr 11, 2012 at 06:36:18PM +0200, Borislav Petkov escreveu:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Now you can do
> > 
> > $ make tools/<toolname>
> > 
> > from the toplevel kernel directory and have the respective tool built.
> > 
> > If you want to build and install it, do
> > 
> > $ make tools/<toolname>_install
> 
> [acme@sandy linux]$ make -j8 O=/home/git/build/perf tools/perf_install
> [acme@sandy linux]$ ls -la tools/perf/*.o | wc -l
> 22
> 
> It should have honoured O=
> 
> Can you fix this one please? :)

I should've known - never break Arnaldo's O= thing! :-)

Sure, I'll take a look at it and I agree, it can go ontop.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
