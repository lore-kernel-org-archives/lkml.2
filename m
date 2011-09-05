Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1IERtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:49:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1IERtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:49:35 -0400
Date: Mon, 5 Sep 2011 10:52:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Player Thread is not woken after period elapsed
Message-ID: <20110905105253.2787b91f@infradead.org>
In-Reply-To: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 23:08:53 +0530
"Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com> wrote:

> Hi,
> 
> When I tried to root cause a glitch in the audio playback, I found a
> weird behavior. 
> 
> User thread which invokes the writei function which in turn  invokes
> a kernel function which waits for the free buffer to write the audio
> data.  This kernel function adds this thread to a wake(sleep) queue
> and calls a schedule_timeout (msecs_to_jiffies(10000)).

actually it doesn't... you must be on some really really old kernel or
something.


> 
> Will you provide some hint on how to go about identifying the root
> cause?

https://lkml.org/lkml/2011/9/5/201



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
