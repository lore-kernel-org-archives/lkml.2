Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1HPHWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:22:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52741 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751135Ab1HPHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:22:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/p5ohOIznpdptdgBx+BBh5WaVm7emw0V25Th9Mdc
	hreKQo9cSPCf1B
Message-ID: <4E4A1AB1.6040001@gmx.de>
Date: Tue, 16 Aug 2011 07:22:25 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Paul Mundt <lethal@linux-sh.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ANNOUNCE] fbdev maintainer change
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

as Paul hasn't been able to catch up with the patches lately and as already 
about half of the development cycle passed I decided to take over maintaining 
the fbdev subsystem, at least for now. So please send all patches you want to go 
mainline via fbdev also directly to me in addition to sending them to linux-fbdev.
Please help me to avoid picking up outdated, buggy versions of your patches by 
resending your final, bug-free ;) version if they are not already included in 
3.1-rc2. I'll be on vacation for a week now, so do not expect immediate 
response, I just wanted to give you some time to polish your patches. When I'm 
back I'll start setting up a fbdev-next branch, probably based on 3.1-rc3, and 
adding your patches to it. So feel free to drown me in patches.
I want to say thanks to Paul for his work, as well as all those people who made 
the fbdev subsystem such a great thing during the past decades and to those who 
are still working to make it even better.


Thanks and happy coding,

Florian Tobias Schandinat
