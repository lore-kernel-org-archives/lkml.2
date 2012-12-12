Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2LLMMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:12:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2LLMMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:12:47 -0500
Date: Wed, 12 Dec 2012 17:42:28 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, sjur@brendeland.net,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        masami.hiramatsu.pt@hitachi.com,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [[PATCH v9 3/3] 1/1] virtio_console: Remove buffers from out_vq
 at port removal
Message-ID: <20121212121228.GA22521@amit.redhat.com>
References: <029d7029bc1186fbd2ec74123dc88922b9600660.1352366215.git.amit.shah@redhat.com>
 <87ip96id3a.fsf@rustcorp.com.au>
 <20121210055401.GA17187@amit.redhat.com>
 <871uexec7e.fsf@rustcorp.com.au>
 <20121211041012.GA16297@amit.redhat.com>
 <87wqwo3zr3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wqwo3zr3.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 12 Dec 2012 [10:31:04], Rusty Russell wrote:
> Amit Shah <amit.shah@redhat.com> writes:
> 
> > On (Tue) 11 Dec 2012 [09:39:41], Rusty Russell wrote:
> >> Amit Shah <amit.shah@redhat.com> writes:
> >> 
> >> > On (Fri) 16 Nov 2012 [11:22:09], Rusty Russell wrote:
> >> >> Amit Shah <amit.shah@redhat.com> writes:
> >> >> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> >> >> >
> >> >> > Remove buffers from the out-queue when a port is removed. Rproc_serial
> >> >> > communicates with remote processors that may crash and leave buffers in
> >> >> > the out-queue. The virtio serial ports may have buffers in the out-queue
> >> >> > as well, e.g. for non-blocking ports and the host didn't consume them
> >> >> > yet.
> >> >> >
> >> >> > [Amit: Remove WARN_ON for generic ports case.]
> >> >> >
> >> >> > Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> >> >> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> >> >> 
> >> >> I already have this in my pending queue; I've promoted it to my
> >> >> virtio-next branch now.
> >> >
> >> > Rusty, I still see this series in your pending queue, not in
> >> > virtio-next.  Did anything change in the meantime?
> >> 
> >> Hmm:
> >> 
> >> 40e625ac50f40d87ddba93280d0a503425aa68e9?
> >
> > I'm sorry, I meant the remoteproc code, not this patch.
> 
> Still waiting for v9, AFIACT?

Instead of sending all patches marked v9, just this patch was
re-spun.  I think you can just pick up patches 1 and 2 from v8 (they
have my acked-by), and patch 3 was an earlier version of this one,
which should just be dropped.

		Amit
