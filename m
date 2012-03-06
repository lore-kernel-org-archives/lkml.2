Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031482Ab2CFWmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:42:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:60251 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031468Ab2CFWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:42:19 -0500
Date: Tue, 6 Mar 2012 23:42:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PATCH RT 04/25][RFC 3.0.23-rt39-rc1]
 revert-seqlock-remove-unused-functions
In-Reply-To: <CAONaPpFnn1EDh-NbJ5=iKw9q4N41KGVfKqJeO0NXvyTLjpzr4w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203062341460.2742@ionos>
References: <20120306161636.491172179@goodmis.org> <20120306161945.770871645@goodmis.org> <CAONaPpFnn1EDh-NbJ5=iKw9q4N41KGVfKqJeO0NXvyTLjpzr4w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, John Kacur wrote:
> On Tue, Mar 6, 2012 at 5:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Does this really need to be reverted? I don't believe the other
> reverts make use of these functions either. Looking upstream ,they are
> also not used here, so the original patch should be pushed upstream if
> anything.

It's applied later on again .... :)
