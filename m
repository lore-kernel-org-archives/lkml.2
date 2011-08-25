Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1HYR1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:27:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59467 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1HYR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <4E568583.40206@parallels.com>
References: <20110824085329.GL29452@sun>
	<20110824111806.GA7191@albatros>
	<20110825082944.GH10030@sun>
	<20110825170147.GM2803@mtj.dyndns.org>
	<4E5680D2.1030608@parallels.com>
	<20110825172109.GC6387@sun>
	<4E568583.40206@parallels.com>
Date: Thu, 25 Aug 2011 19:27:34 +0200
X-Google-Sender-Auth: SU2q3VlMS2_tUIJV-4fCe76Eb1E
Message-ID: <CAOS58YOSLrfFaUgaDEZyjAPuEHrB9PmVi9TTz=HROtYuwRQuRA@mail.gmail.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 7:25 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
> Not exactly - as I said if we leave the name without 0x (3d000000 instead of 0x3d000000)
> this makes it hard to use strtol() on these strings to convert names to addresses.

But strtol() has @base.

Thanks.

-- 
tejun
