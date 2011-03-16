Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1CPLbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:31:03 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3662 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CPLaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:30:55 -0400
Date: Wed, 16 Mar 2011 12:30:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree 
 (jdelvare-hwmon  tree related)
Message-ID: <20110316123030.68bdbdcb@endymion.delvare>
In-Reply-To: <20110315212226.7e940b51.sfr@canb.auug.org.au>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
	<4D7F2609.3080508@redhat.com>
	<20110315103228.30233acc@endymion.delvare>
	<20110315212226.7e940b51.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 21:22:26 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Tue, 15 Mar 2011 10:32:28 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> >
> > Stephen, sorry for the inconvenience, both Hans and myself build-tested
> > the new code on an architecture where <linux/delay.h> gets included
> > implicitly, so we didn't notice it was missing.
> 
> It happens.  It seems that delay.h is almost always the one that is
> forgotten.  X86 builds include it implicitly but powerpc doesn't.
> 
> I wonder if we could concoct a nice checkpatch test for it.

Would certainly be a good idea, yes. Probably not trivial though.

-- 
Jean Delvare
