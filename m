Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0JQAf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:35:58 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:39517 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756937Ab0JQAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:35:57 -0400
Date: Sun, 17 Oct 2010 11:35:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101017003526.GA29677@dastard>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 02:10:29PM -0700, H. Peter Anvin wrote:
> "Christoph Hellwig" <hch@infradead.org> wrote:
> >Besides the algorithmic problems with ima, why is kernel.org using
> >IMA to start with?  Except for IBM looking for a reason to jusity why
> >TPM isn't a completely waster of ressources it's pointless.  And it was
> >only merged under the premise that it would not affect innocent normal
> >users.
>
> I'm confused ... what makes you think we are?  This might have
> been an unintentional misconfiguration...

It's enabled in the kernel that is running:

$ grep CONFIG_IMA /boot/config-2.6.34.7-56.fc11.x86_64
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
$

and it's using lots of memory, so if you're not actually using it I
think it should be disabled.

If this is a stock fedora config, then they've got some work to
do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
