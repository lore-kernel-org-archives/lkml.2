Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2C1HfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:35:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45127 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2C1He7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:34:59 -0400
Date: Wed, 28 Mar 2012 09:34:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
Message-ID: <20120328073454.GC22885@gmail.com>
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
 <20120327162633.654c8d7e.akpm@linux-foundation.org>
 <CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com>
 <20120328064008.GA12735@gmail.com>
 <4F72BBCE.1060307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F72BBCE.1060307@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/27/2012 11:40 PM, Ingo Molnar wrote:
> > 
> > No objections from me.
> > 
> > Please resubmit against latest -tip, we unified the idle 
> > routines which likely interacts with that patch.
> 
> To the best of my knowledge, no-hlt only existed because of 
> flaky power distributions on 386/486 systems which were sold 
> to run DOS.  Since DOS did no power management of any kind, 
> including HLT, the power draw was fairly uniform; when exposed 
> to the much higher noise levels you got when Linux used HLT 
> caused some of these systems to fail.
> 
> They were by far in the minority even back then.

This information should be added to the changelog.

Thanks,

	Ingo
