Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1EMRvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:51:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1EMRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YoNQhlG+zmN7++Fp8G+rmmk9mvPC6rCq0+wjxEdDGigETLEioAtEQr06ZvtsauPtBL
         wVCb58omlTK4DO/c7oLNTUzSFGmUUyoq9dyDtAonqgsLw1ilK/tXOCeir2FPakjXiKy+
         lk0nQw6QfIvCD/leS3VFTlrQrbcxT6g7XWDoc=
MIME-Version: 1.0
In-Reply-To: <20110513173633.GA14607@jayachandranc.netlogicmicro.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<20110513150707.GA26389@linux-mips.org>
	<BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
	<20110513155605.GA30674@linux-mips.org>
	<BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
	<20110513173633.GA14607@jayachandranc.netlogicmicro.com>
Date: Fri, 13 May 2011 10:51:44 -0700
Message-ID: <BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:36 AM, Jayachandran C.
<jayachandranc@netlogicmicro.com> wrote:
> For 32-bit the config is nlm_xlr_defconfig in the source tree. Let me know if
> you need any further info.

Would you be able to dump out the TLB handlers in this configuration,
per David's suggestion?

Thanks.
