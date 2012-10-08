Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2JHKYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:24:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab2JHKYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:24:48 -0400
Date: Mon, 8 Oct 2012 12:25:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v3]mconf: Add Save button
Message-ID: <20121008102526.GA18308@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121008050513.GA22078@udknight>
 <20121008060340.GB4148@liondog.tnic>
 <20121008072249.GA29113@udknight>
 <20121008082832.GB19783@liondog.tnic>
 <20121008084544.GA1695@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121008084544.GA1695@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:45:44PM +0800, Wang YanQing wrote:
> By the way,just a quick test, qconfig, xconfig, nconfig all have the
> Save button, why do them exist if we follow your opinion?

Because someone added them thinking it would be cool to have them, what
do I know...

In any case, I still fail to see a real value in this considering the
use case, that's all. Unless someone proves me wrong with a better
example that this...

Thanks.

-- 
Regards/Gruss,
Boris.
