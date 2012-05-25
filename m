Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2EYJUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:20:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:57874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2EYJUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:20:12 -0400
Subject: Re: [RFC PATCH 1/4 V2] livedump: Add notifier-call-chain into
 do_page_fault
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20120525091207.10256.15550.stgit@t3500.sdl.hitachi.co.jp>
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
	 <20120525091207.10256.15550.stgit@t3500.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 11:19:56 +0200
Message-ID: <1337937596.9783.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 18:12 +0900, YOSHIDA Masanori wrote:
> 
> This patch adds notifier-call-chain that is called in do_page_fault.
> Livedump uses this to check if page fault is caused by livedump, and if so,
> the fault is handled by livedump's handler function. Otherwise, it is
> handled by the original page fault handler. 

No, please no notifiers..



