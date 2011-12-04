Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1LDUeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:34:44 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:58502 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1LDUen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:34:43 -0500
X-Greylist: delayed 1255 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Dec 2011 15:34:38 EST
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Sander & Lighting
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
Date: Sun, 4 Dec 2011 21:13:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc2-00143-ga767835; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
References: <20111204185444.411298317@goodmis.org>
In-Reply-To: <20111204185444.411298317@goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112042113.37047.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.12.4.200615
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven
> This is the RT stable review cycle of patch 3.0.12-rt30-rc2.
> 
> Please scream at me if I messed something up. Please test the patches too.
Ok, this is a nearly blind shot, but i was expieriencing strange idle time 
behaviour with this Ingo Molnar patch. The idle time was never incremented as 
read from /proc/stat for several minutes. The system itself was behaving fine
and had definetly not 100% load which was also verified with top.

I hadn't had the time to investigate further and my tests where with an ealier 
release with the Ingo Molnar Tasklet patch on top.

Hopefully i will find some time to test this stuff further but it will 
probably tuesday CET.

Best regards
Tim
