Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1H3EcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:32:25 -0400
Received: from relais.videotron.ca ([24.201.245.36]:30512 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1H3EcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:32:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 30 Aug 2011 00:32:23 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
In-reply-to: <CACqU3MVrSV-Qp7mC4iN_viMHz=2-cGPaqNY04eokYkVoE_pSuw@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1108300028470.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
 <CACqU3MVrSV-Qp7mC4iN_viMHz=2-cGPaqNY04eokYkVoE_pSuw@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Arnaud Lacombe wrote:

> On Fri, Aug 19, 2011 at 8:37 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > With the attached patch, we would do:
> >
> > arch/foo/boot/Makefile:
> > LDFLAGS_fancy.o := -DPANTS=30
> > obj-y += fancy.o
> > vpath-y += $(srctree)/arch/foo/lib
> >
> > and let GNU make do the job.
> >
> Nicolas, I guess you were the one who was interested for a generic way
> to do such code re-use, did you had any chance to test the quoted
> patch ?

I actually missed the original post (I wasn't in CC) so I didn't test it. 
Will try to do so ASAP.


Nicolas
