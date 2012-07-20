Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab2GTQcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:32:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57675 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2GTQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <1342769360.2984.2.camel@dabdike.int.hansenpartnership.com>
References: <20120720103254.4a043ea94ef16992466a8b19@canb.auug.org.au> <1342769360.2984.2.camel@dabdike.int.hansenpartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Jul 2012 09:31:39 -0700
X-Google-Sender-Auth: F6yvEs8E39JvE5ez0xOjoIDW0tg
Message-ID: <CA+55aFxiichhzqokzAmHMEEUW1286V0d37YaStcOH_e=OutDiA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the scsi tree with Linus' tree
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 12:29 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> By the way, Linus, the patch says:
>
>     Cc: Dan Williams <dan.j.williams@gmail.com>
>     Cc: Alan Stern <stern@rowland.harvard.edu>
>     Cc: James Bottomley <jbottomley@parallels.com>
>     Cc: Borislav Petkov <bp@amd64.org>
>     Cc: linux-scsi <linux-scsi@vger.kernel.org>
>
> But best I can tell it never went to either me or linux-scsi.

Both you and linux-scsi were cc'd at least in some of the discussion. Search for

  "a7a20d103994fd760766e6c9d494daa569cbfe06 makes kernel 3.5
unbootable on an Intel chipset based motherboard"

but most of the noise is in the bugzilla itself:

  https://bugzilla.kernel.org/show_bug.cgi?id=44771

and it may well be that you weren't listed for the bugzilla entry.

Ugh, how I hate bugzilla.

                Linus
