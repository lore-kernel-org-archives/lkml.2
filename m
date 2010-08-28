Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab0H1FYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 01:24:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48923 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0H1FYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 01:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <B3286B71-599C-405E-847F-06B843A46449@suse.de>
References: <1282936005-17078-1-git-send-email-Kyle.D.Moffett@boeing.com> <B3286B71-599C-405E-847F-06B843A46449@suse.de>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 28 Aug 2010 01:24:14 -0400
Message-ID: <AANLkTimwBL42bAxa5okPeJ-y_oSCfp05_POxxRasZGFn@mail.gmail.com>
Subject: Re: [PATCH] powerpc/kvm/e500_tlb: Fix a minor copy-paste tracing bug
To: Alexander Graf <agraf@suse.de>
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Liu Yu <yu.liu@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 20:58, Alexander Graf <agraf@suse.de> wrote:
> On 27.08.2010, at 21:06, Kyle Moffett wrote:
>> The kvmppc_e500_stlbe_invalidate() function was trying to pass too many
>> parameters to trace_kvm_stlb_inval().  This appears to be a bad
>> copy-paste from a call to trace_kvm_stlb_write().
>
> Which kernel is this against? That trace point is already commented out in my tree.

Oh, hm, I guess I haven't rebased this patch since 2.6.35-ish.  The
trace point seems to work correctly with the fixed arguments; if
you'll tell me which tree I should base it on I can easily resubmit.

Cheers,
Kyle Moffett
