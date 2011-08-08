Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HHXcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:32:08 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:50744 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752279Ab1HHXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:32:07 -0400
Date: Mon, 8 Aug 2011 16:32:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.1-rc1 (staging/comedi)
Message-Id: <20110808163204.05c184af.rdunlap@xenotime.net>
In-Reply-To: <20110808215153.GA10848@suse.de>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
	<20110808143516.517a40cc.rdunlap@xenotime.net>
	<20110808215153.GA10848@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 14:51:53 -0700 Greg KH wrote:

> On Mon, Aug 08, 2011 at 02:35:16PM -0700, Randy Dunlap wrote:
> > on x86_64:
> > 
> > ERROR: "labpc_1200_is_unipolar" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> > ERROR: "labpc_1200_ai_gain_bits" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> > ERROR: "range_labpc_1200_ai" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> > ERROR: "labpc_common_detach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> > ERROR: "labpc_common_attach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> > 
> > Full kernel (rand)config is attached.
> 
> I don't see how this could happen, as you have:
> 
> CONFIG_COMEDI_NI_LABPC_CS=m
> CONFIG_COMEDI_NI_LABPC=m
> 
> set.  Those functions are all in
> drivers/staging/comedi/drivers/ni_labpc.ko, which should have also
> gotten built, right?
> 
> totally confused,

Ack.  Misleading messages logged due to using -k on build.
Sorry about that.  There are some build errors (in linux-next).
I'll send those in reply to today's linux-next announcement.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
