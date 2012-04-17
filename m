Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2DQPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:44:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:60525 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2DQPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:44:33 -0400
Message-ID: <1334677466.1435.0.camel@localhost.localdomain>
Subject: Re: 3.3.2 - Crash in kthread_data (power_supply_core/led?)
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cbou@mail.ru,
        stern@rowland.harvard.edu, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 17 Apr 2012 17:44:26 +0200
In-Reply-To: <201204152036.41938.rjw@sisk.pl>
References: <1334481858.1444.20.camel@localhost.localdomain>
	 <201204152036.41938.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 15.04.2012, 20:36 +0200 schrieb Rafael J. Wysocki:
> On Sunday, April 15, 2012, Thomas Meyer wrote:
> > Hi,
> > 
> > I resumed my computer from RAM today and found this crash on the text
> > console -> see attachment. One LED was blinking, (PS2 attached) keyboard
> > didn't react anymore and I had to reboot my machine.
> > 
> > I couldn't capture the whole dump, the crash didn't made it to the log
> > on disk, so I only have this screenshot. It's the first time I see this
> > crash with any kernel. I did update to 3.3.2 yesterday, but maybe this
> > is unrelated.
> > 
> > The crash looks like the power_supply_core/led wants to send some event
> > and then things goes awry.
> 
> This looks like a delayed work item triggering at a wrong time.
> 
> I guess that the leds' suspend forgets to cancel its delayed work itmes which
> then may be started during system resume.

just resumed my machine again and same crash. again I needed to reboot
my machine. I never had these problems with 3.2.x kernels.

> 
> Thanks,
> Rafael



