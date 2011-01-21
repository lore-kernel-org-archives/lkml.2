Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1AUSEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:04:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60403 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1AUSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:04:06 -0500
Date: Fri, 21 Jan 2011 19:06:27 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "acme@infradead.org" <acme@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ras: Add RAS daemon
Message-ID: <20110121180627.GA19016@aftab>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-13-git-send-email-bp@amd64.org>
 <AANLkTinWZr7Ps-B+YT7tZm4+1=mTOGutUWWfi9L59wra@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinWZr7Ps-B+YT7tZm4+1=mTOGutUWWfi9L59wra@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:54:20PM -0500, Tony Luck wrote:
> On Fri, Jan 21, 2011 at 7:09 AM, Borislav Petkov <bp@amd64.org> wrote:
> > +       format_buf = malloc_or_die(fsize);
> > +       if (!format_buf)
> > +               die("allocating format buffer");
> 
> You don't trust "malloc_or_die()" to make it dead enough? :-)

Yeah, it ain't dead yet! That's me with the big hammer.

Good catch, will fix.

> Will take a look through the rest of bits - looks very interesting.

Thanks a lot sir :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
