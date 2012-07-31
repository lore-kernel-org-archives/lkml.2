Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2GaGXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:23:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51612 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2GaGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:23:08 -0400
Date: Tue, 31 Jul 2012 09:22:57 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Michael Ellerman <michael@ellerman.id.au>
cc: Matt Evans <matt@ozlabs.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        prerna@linux.vnet.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
In-Reply-To: <1342577283.25827.8.camel@concordia>
Message-ID: <alpine.LFD.2.02.1207310922290.2405@tux.localdomain>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>  <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>  <CAOJsxLGf6K0G90i==-TJ8WmGvuwtp9mpxsCMSJYw7Wn-JAvpcA@mail.gmail.com> <1342577283.25827.8.camel@concordia>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012, Michael Ellerman wrote:
> It occurred to me overnight that I forgot to mention that in order to
> build the new code you need the headers from a 3.5-rc1 era kernel (for
> the ioctl & KVM_CAP definitions).
> 
> The easiest way to do that is to merge linus' tree into kvmtool.
> 
> Are you planning on doing that in the master kvmtool tree anytime soon?
> It's still based on 3.4-rc1 it seems.

Done. Sorry for the delay!
