Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2H2RXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2H2RXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:23:10 -0400
Date: Wed, 29 Aug 2012 13:22:54 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Bruno Wolff III <bruno@wolff.to>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120829172254.GB1895@zod.bos.redhat.com>
References: <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
 <5038C186.7000107@gmail.com>
 <20120825121758.GF20043@zod.bos.redhat.com>
 <503DFC61.3000104@gmail.com>
 <s5hsjb56d40.wl%tiwai@suse.de>
 <503E19F2.3080302@gmail.com>
 <20120829170753.GA1895@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829170753.GA1895@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 01:07:53PM -0400, Josh Boyer wrote:
> > Right. New patch attached.
> 
> I'll try and get another kernel built with this later today.  I'm at
> Plumbers so it might have to wait a bit.

OK, I got impatient with myself and got the kernel building sooner than
I said.  Bruno, you can find the kernel here when the build finishes:

http://koji.fedoraproject.org/koji/taskinfo?taskID=4434883

Please test and let us know.

josh
