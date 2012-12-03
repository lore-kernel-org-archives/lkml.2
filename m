Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2LCUAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:00:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56241 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751279Ab2LCUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:00:14 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX19M7zJ/Zp9MY4UwZwjBcZIF5okCY5rM8iOulCUAtC
	62xLMUaJTkF3QC
Date: Mon, 3 Dec 2012 22:00:06 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@soupermouf
To: Eric Paris <eparis@parisplace.org>, "Theodore Ts'o" <tytso@mit.edu>
cc: Roland Eggner <edvx1@systemanalysen.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
In-Reply-To: <alpine.LFD.2.02.1212032125520.4173@soupermouf>
Message-ID: <alpine.LFD.2.02.1212032157480.4173@soupermouf>
References: <1353855815.22969.20.camel@soupermouf> <1354452243.22969.48.camel@soupermouf> <20121202225051.GA13685@mobil.systemanalysen.net> <alpine.LFD.2.02.1212030120090.1646@soupermouf> <20121203174342.GB20260@thunk.org>
 <CACLa4psEfdA17mcjVHhUfgmARXTZ6AVA7QJ77DymXBeVtgjZ5w@mail.gmail.com> <alpine.LFD.2.02.1212032125520.4173@soupermouf>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012, Dimitrios Apostolou wrote:
>
> I've managed to reproduce the scenario with concurrent "du" commands running 
> on the filesystems. I'll try doing it once more, but it may take a while to 
> get the dmesg/slabinfo etc output, since even a realtime root shell is 
> non-responsive for many minutes.
>
> What other debug output do you suggest to get, to find out why ext4 inodes 
> are pinned?

Important detail: one of the filesystems contains *huge* maildirs, 
containing hundreds of thousands of messages.


Dimitris

