Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab2AMUgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:36:54 -0500
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:42319 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932798Ab2AMUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:36:53 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 15:36:53 EST
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Sander & Lighting
To: Bernardo Barros <bernardobarros2@gmail.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
Date: Fri, 13 Jan 2012 21:30:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc3; KDE/4.6.5; x86_64; ; )
Cc: Tim Sander <tim.sander@hbm.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201131042.08323.tim.sander@hbm.com> <CAOEEKGXUJC9Mmu7azKSvQNkoB3Z_aLPTCDWABOE5WpHRKR=YNg@mail.gmail.com>
In-Reply-To: <CAOEEKGXUJC9Mmu7azKSvQNkoB3Z_aLPTCDWABOE5WpHRKR=YNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201132130.38592.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.1.13.201516
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> Will 3.0-rt continue to receive bugfixes in parallel with 3.2-rt? Will
> it be a LTS kernel as 3.0 is?
As far as i remember: Steve Rosted announced on this list that he will 
maintain 3.0-rt and Thomas Gleixner will be working on future 3.2-rt releases.

3.0 is also a "stable" kernel maintained by Greg KH i think.

Tim
