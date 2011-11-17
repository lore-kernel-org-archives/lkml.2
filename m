Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1KQN3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:29:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40425 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1KQN3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:29:42 -0500
Date: Thu, 17 Nov 2011 14:29:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Jason Baron <jbaron@redhat.com>,
        rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111117132939.GB2215@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, Jason Baron <jbaron@redhat.com>,
	rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321534159.27735.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 01:49:19PM +0100, Peter Zijlstra wrote:
> Ideally we'd fix text_poke to not use stop_machine() we know how to,
> but we haven't had the green light from Intel/AMD yet.

We talked about it briefly with hpa and tglx at KS. AFAICR, there's a
patchset in the works...

-- 
Regards/Gruss,
   Boris
