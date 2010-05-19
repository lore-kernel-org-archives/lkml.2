Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0ESJql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:46:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46284 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326Ab0ESJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:46:38 -0400
Date: Wed, 19 May 2010 10:53:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, sr@denx.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> < resubmission
 >
Message-ID: <20100519105305.54804b57@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTiljlMJKimdT-ptwXrMMBhSxFuPdVdyUuKJ8BZve@mail.gmail.com>
References: <201005051757.o45HvPmY005954@amcc.com>
	<AANLkTiljlMJKimdT-ptwXrMMBhSxFuPdVdyUuKJ8BZve@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 10:49:59 +0900
Jassi Brar <jassisinghbrar@gmail.com> wrote:

> On Thu, May 6, 2010 at 2:57 AM, Rupjyoti Sarmah <rsarmah@amcc.com> wrote:
> > This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
> 
> The controller seems to be a thrid party IP (from Synopsys) in your
> SoC and there are many chances the IP will appear in some other
> SOCs too. This implementation doesn't seem to take care of that
> scenario.

I'd question if that is worth it seriously. At the point there are
multiple users of the device you know what it will look like. Until then
you neither know if the work is needed nor what will require abstracting.

Lazy evaluation is good for code too ;)

Alan
