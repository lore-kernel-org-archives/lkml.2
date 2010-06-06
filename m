Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0FFKUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:20:25 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54378 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186Ab0FFKUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:20:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: regression: 2.6.35-rc1 hangs on i865G with KMS
Date: Sun, 6 Jun 2010 12:20:13 +0200
User-Agent: KMail/1.9.10
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <201006042201.29872.linux@rainbow-software.org> <201006052228.03025.linux@rainbow-software.org> <AANLkTinLPi93TvXcudNKPPWQaiD6xUrqvEESoxHnlIif@mail.gmail.com>
In-Reply-To: <AANLkTinLPi93TvXcudNKPPWQaiD6xUrqvEESoxHnlIif@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006061220.15579.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010 11:04:44 Dave Airlie wrote:
> On Sun, Jun 6, 2010 at 6:28 AM, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Saturday 05 June 2010 02:23:27 Eric Anholt wrote:
> >> On Fri, 4 Jun 2010 22:01:28 +0200, Ondrej Zary 
<linux@rainbow-software.org> wrote:
> >> > Hello,
> >> > I'm testing 2.6.35-rc1 kernel on Asus P4P800-VM (i865G chipset). After
> >> > loading i915 module, the screen goes blank and the kernel hangs
> >> > completely (same with 2.6.35-rc1-git2). This does not happen with
> >> > "i915.modeset=0" parameter.
> >> >
> >> > This problem does not appear with 2.6.34. Is this a known regression?
> >>
> >> Not known as far as I know -- we'd enjoy a bisect with a bug report on
> >> bugs.freedesktop.org.
>
> Can you try the attached patch?

Thanks, applied it on 2.6.35-rc2 and it seems to work fine.


-- 
Ondrej Zary
