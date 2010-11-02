Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0KBRhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:37:19 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:56123 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab0KBRhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:37:15 -0400
Date: Tue, 2 Nov 2010 11:37:10 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD boot freeze bisected to
 b126b4703afa4010b161784a43650337676dd03b
Message-ID: <20101102173710.GA2205@helgaas.com>
References: <20101102170335.GC24927@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102170335.GC24927@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 06:03:35PM +0100, Borislav Petkov wrote:
> I am testing 37-rc1 on a quad-socket MCM system (48 cores) and it
> freezes during boot with the messages below:
> ... 
> 
> Bisecting the kernel gave the following results and reverting
> b126b4703afa4010b161784a43650337676dd03b does really fix booting. Let me
> know what info you'd need/patches tested for debugging this.

Thanks very much for testing this.  Can you collect the complete
dmesg please?  We need the information about the host bridge
windows and the device that we assigned resources to, and the
snippet you included doesn't have that.

If you're able to boot Windows and collect an Everest report
(http://lavalys.com), that would be a great bonus.  The goal
is to allocate things the same way Windows does, but obviously
I failed somewhere.

Bjorn
