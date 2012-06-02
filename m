Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab2FBU60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:58:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46236 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812Ab2FBU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:58:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120601225754.GA25281@electric-eye.fr.zoreil.com>
References: <20120530214809.GA19223@redhat.com>
	<alpine.LFD.2.02.1205310938080.3231@ionos>
	<20120601225754.GA25281@electric-eye.fr.zoreil.com>
Date: Sat, 2 Jun 2012 16:58:23 -0400
Message-ID: <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
Subject: Re: NOHZ: local_softirq_pending 08
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it helps, I've been seeing the same thing here on a system with an
r8169.  The message appears consistently enough on network startup to
be able to track it down to this specific commit:
    98ddf986fca17840e46e070354b7e2cd2169da15: r8169: bh locking redux
and task scheduling.

The softirq pending messages always come right after "link down"
messages for the interface.

Marc
