Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2H2SwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:52:15 -0400
Received: from wolff.to ([65.117.131.163]:60317 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753969Ab2H2SwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:52:14 -0400
Date: Wed, 29 Aug 2012 13:50:34 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120829185034.GA16456@wolff.to>
References: <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
 <5038C186.7000107@gmail.com>
 <20120825121758.GF20043@zod.bos.redhat.com>
 <503DFC61.3000104@gmail.com>
 <s5hsjb56d40.wl%tiwai@suse.de>
 <503E19F2.3080302@gmail.com>
 <20120829170753.GA1895@zod.bos.redhat.com>
 <20120829172254.GB1895@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20120829172254.GB1895@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 13:22:54 -0400,
   Josh Boyer <jwboyer@redhat.com> wrote:
>On Wed, Aug 29, 2012 at 01:07:53PM -0400, Josh Boyer wrote:
>> > Right. New patch attached.
>>
>> I'll try and get another kernel built with this later today.  I'm at
>> Plumbers so it might have to wait a bit.
>
>OK, I got impatient with myself and got the kernel building sooner than
>I said.  Bruno, you can find the kernel here when the build finishes:
>
>http://koji.fedoraproject.org/koji/taskinfo?taskID=4434883
>
>Please test and let us know.

I tested 3.6.0-0.rc3.git2.1.3.fc18.x86_64 on my machine at work and sound 
through the headset is working. I'll test my i686 machines at home tonight.
