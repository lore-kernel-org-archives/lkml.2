Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2H2Pv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:51:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55067 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab2H2Pv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:51:27 -0400
Date: Wed, 29 Aug 2012 17:51:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: use new exception_enter()/exception_exit() API
 in do_device_not_available()
Message-ID: <20120829155135.GA18057@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20120828210047.GA22279@swordfish>
 <20120828221111.GC9297@liondog.tnic>
 <20120829044255.GA3147@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120829044255.GA3147@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 07:42:55AM +0300, Sergey Senozhatsky wrote:
> OH! NO WAY I did that mistake! That was some last minute
> in-text-editor changes and somehow I screwed this up. Will re-send in
> a second.
>
> Sorry, and thank you.

I wouldn't worry - it can happen to anyone (and I'm talking from
experience here) :-).

-- 
Regards/Gruss,
Boris.
