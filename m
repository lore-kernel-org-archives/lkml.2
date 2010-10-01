Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0JAUwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:52:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:44986 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab0JAUwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:52:11 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Josh Boyer <jwboyer@gmail.com>, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	 <1285935283.2463.78.camel@pasglop>
	 <BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 06:51:55 +1000
Message-ID: <1285966315.2463.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 12:59 -0500, Kumar Gala wrote:
> I'm not against it, and I agree some of the patches seem like good
> clean up.  I'm concerned about this bit rotting pretty quickly.

Maybe. Most of it doesn't seem to be that bit-rottable.

The changes to the asm stuff in misc_32.S for example are functions we
never ever touch once written (libgcc replacements) so I don't see them
rotting more with LE support than they did with BE :-)

What might rot is that we might introduce new LE breakage, true, and I
suppose it's going to be to some extent my job to at least every now and
then shoot that thing on a 44x to see if it still flies.

Cheers,
Ben.

