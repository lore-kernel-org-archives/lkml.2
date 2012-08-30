Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2H3PFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:05:30 -0400
Received: from wolff.to ([65.117.131.163]:60815 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752001Ab2H3PF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:05:27 -0400
Date: Thu, 30 Aug 2012 10:03:38 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, Josh Boyer <jwboyer@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120830150338.GA17727@wolff.to>
References: <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
 <5038C186.7000107@gmail.com>
 <20120825121758.GF20043@zod.bos.redhat.com>
 <503DFC61.3000104@gmail.com>
 <s5hsjb56d40.wl%tiwai@suse.de>
 <503E19F2.3080302@gmail.com>
 <s5hehmo5v3x.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5hehmo5v3x.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 16:10:10 +0200,
   Takashi Iwai <tiwai@suse.de> wrote:
>
>As the test result looks positive, I applied it for the next pull
>request.   Thanks.

I tested 3.6.0-0.rc3.git3.2.fc18.i686.PAE (which inlcudes the patches) on two 
more machines last night and it worked on them as well.
