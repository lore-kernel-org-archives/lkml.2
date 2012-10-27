Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2J0IsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:48:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:37035 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2J0IsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:48:01 -0400
Date: Sat, 27 Oct 2012 10:47:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [ANNOUNCE] 3.6.3-rt7
In-Reply-To: <CAJL_dMvBKu_6-4HXL3YR-UeJ6CeHJadL26fvhO8wjw6OdA9wxw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210271045470.2756@ionos>
References: <alpine.LFD.2.02.1210262036270.2756@ionos> <alpine.LFD.2.02.1210270006130.2756@ionos> <CAJL_dMvBKu_6-4HXL3YR-UeJ6CeHJadL26fvhO8wjw6OdA9wxw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2012, Anca Emanuel wrote:

> On Sat, Oct 27, 2012 at 1:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Looks like CONFIG_NUMA=y exposes explosions. I just noticed that none
> > of the machines which are in my basic set of test systems have that
> > enabled.
> >
> > /me goes to do some homework
> 
> Try https://github.com/torvalds/linux/commit/6b187d0260b6cd1d0904309f32659b7ed5948af8
> 
> (mm, numa: avoid setting zone_reclaim_mode unless a node is
> sufficiently distant)

This is completely irrelevant. It fixes a post 3.6 issue and has
nothing to do with the problem at hand.
