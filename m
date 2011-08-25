Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1HYReZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:34:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65391 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1HYReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:34:22 -0400
Date: Thu, 25 Aug 2011 21:34:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110825173416.GD6387@sun>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825170147.GM2803@mtj.dyndns.org>
 <4E5680D2.1030608@parallels.com>
 <20110825172109.GC6387@sun>
 <4E568583.40206@parallels.com>
 <CAOS58YOSLrfFaUgaDEZyjAPuEHrB9PmVi9TTz=HROtYuwRQuRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOSLrfFaUgaDEZyjAPuEHrB9PmVi9TTz=HROtYuwRQuRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 07:27:34PM +0200, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 25, 2011 at 7:25 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
> > Not exactly - as I said if we leave the name without 0x (3d000000 instead of 0x3d000000)
> > this makes it hard to use strtol() on these strings to convert names to addresses.
> 
> But strtol() has @base.
> 

That's ok. Tejun, i'll think a bit more (probably tomorrow already, since I'll
be reworking it and adding a check for permissions nit you've pointed) and will
check if there is a nice way to make the names longer ;)

	Cyrill
