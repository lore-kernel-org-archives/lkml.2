Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1EEUjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:39:20 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:59936 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1EEUjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:39:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19907.2804.330120.193924@pilspetsen.it.uu.se>
Date: Thu, 5 May 2011 22:39:16 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux/m68k <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
In-Reply-To: <alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven writes:
 > On Thu, 5 May 2011, Arnd Bergmann wrote:
 > > Did you check the macros in unistd to see if they match the
 > > actual table? I guess it would be a good time to comment out
 > > the ones that are not implemented in either of the two ABIs.
 > 
 > Like this?
 > 
 > warning: #warning syscall pselect6 not implemented
 > warning: #warning syscall ppoll not implemented
 > warning: #warning syscall recvmmsg not implemented
 > 
 > Do we need pselect6 and ppoll? I have vague memories not requiring it.

They close user-space race conditions, so you want them.
