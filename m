Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab0JSNgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:36:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0JSNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:36:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Date: Tue, 19 Oct 2010 15:36:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        ksummit-2010-discuss@lists.linux-foundation.org
References: <201009161632.59210.arnd@arndb.de> <201010190926.54635.arnd@arndb.de> <1287491998.16971.360.camel@gandalf.stny.rr.com>
In-Reply-To: <1287491998.16971.360.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191536.33373.arnd@arndb.de>
X-Provags-ID: V02:K0:1T+eaG6rfGA2DrmJsx666+iatBWQCG9j5PN9/c/1rsJ
 JR+NFRkbFThRI/tAVoVJ8bUxxeKt//x9SiqblIjDPhm4QCc2Gl
 VUy25l59+eKmtRjt+Ryuv+vnp2HlA6MIyuwub5ISLdg4+p4v3e
 DLrqoQmGWnzypgjsehQQjfpD9I4DKibF5NBijrUbzaOZEejguW
 0GUGJbxXl5/9sL4bMoVBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimming Cc list]

On Tuesday 19 October 2010, Steven Rostedt wrote:
> I think we also need to cover the PREEMPT case too. But that could be a
> compile time check, since you can't boot a preempt kernel and make it
> non preempt.

Right. Can we turn the lock_kernel() into preempt_disable() in these
drivers when we know we never run on SMP?

	Arnd
