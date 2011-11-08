Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1KHWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:07:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1KHWHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:07:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: Linux 3.2-rc1
Date: Tue, 8 Nov 2011 23:10:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com> <20111108144345.7555fa01@x220> <CACVXFVPLO_+-LwAGzooPALCUEEpvKDZuGm-T6C9FkPo46n63JQ@mail.gmail.com>
In-Reply-To: <CACVXFVPLO_+-LwAGzooPALCUEEpvKDZuGm-T6C9FkPo46n63JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111082310.14465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 08, 2011, Ming Lei wrote:
> On Tue, Nov 8, 2011 at 9:43 PM, Udo Steinberg <udo@hypervisor.org> wrote:
> > On Mon, 7 Nov 2011 18:10:02 -0800 Linus Torvalds (LT) wrote:
> >
> > LT> Have fun, give it a good testing. There shouldn't be anything hugely
> > LT> scary in there, but there *is* a lot of stuff. The fact that 3.1
> > LT> dragged out did mean that this ended up being one of the bigger merge
> > LT> windows, but I'm not feeling *too* nervous about it.
> >
> > Hi,
> >
> > The formatting of /proc/misc broke for cpu_dma_latency. This causes programs
> 
> The patch in blow link can fix the issue, maybe Rafael will push it out in -rc2.
> 
> http://marc.info/?l=linux-pm&m=132065404031749&w=2

Yes, I've just sent a pull request with this one.

Thanks,
Rafael
