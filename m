Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1J1Hr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:47:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56426 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1J1HrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:47:24 -0400
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Sasha Levin <levinsasha928@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <20111028073915.GA27593@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	 <20111027193448.GA3514@merkur.ravnborg.org>
	 <20111028070336.GF12995@elte.hu> <1319786635.3235.11.camel@lappy>
	 <20111028073915.GA27593@elte.hu>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 28 Oct 2011 09:47:19 +0200
Message-ID: <1319788039.3235.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 09:39 +0200, Ingo Molnar wrote:
> * Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > > ? It would be very obvious at a glance what it does.
> > 
> > We can possibly make 'make defconfig abc' run arch specific script 
> > located next to the defconfig files (arch/$(ARCH)/configs/).
> 
> AFAICS that's not the same as the current kvmconfig functionality 
> though: we want to minimally enable certain config options in the 
> current .config - not pick some default config.

Yup, I wasn't planning on it to work like defconfig does where it just
uses a default config, thats why I said 'run arch specific script' :)

That script could either copy over a default config, or simply add
config options like what we're interested in doing.

-- 

Sasha.

