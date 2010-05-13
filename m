Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab0EMKed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:34:33 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50543 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0EMKec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:34:32 -0400
Date: Thu, 13 May 2010 12:34:26 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100513103426.GC6793@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273706072.2295.67.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Reinette,

On Wed, 2010-05-12 at 07:39 -0700, Nils Radtke wrote:
> > Problem regarding the deauths/reconnects (sometimes combined w/ bad throughput):
> > 
> >   Tested w/ Linux mypole 2.6.33.3 #21 SMP PREEMPT Tue May 11 11:41:07 CEST 2010 i686 GNU/Linux
> >   and iwl recovery patches applied.
> > 
> 
> Any chance you can try these same tests with latest code
> (compat-wireless may be easiest) to help us determine if this is still
> an issue?
I'll try those. Have to recompile the kernel though as I used to have config_80211 in instead of M.

> > RFKILL switch on, wpa_cli stat showed auth.
> > 
> > First auth: conn failed during https login
> > 
> > [28018.602587] eth1: deauthenticated from 00:40:96:aa:bb:cc (Reason: 2)
> > [28018.900400] iwlagn 0000:03:00.0: TX Power requested while scanning!
> > [28018.900411] iwlagn 0000:03:00.0: Error sending TX power (-11)
> > [28018.921465] iwlagn 0000:03:00.0: request scan called when driver not ready.
> 
> We could maybe at least figure out what is going on here if the driver
> is loaded with some debugging. Please ensure driver is compiled with
> debugging (CONFIG_IWLWIFI_DEBUG) and load the module with "modprobe
> iwlagn debug=0x43fff". Could you please reproduce under this
> environment?
Ok.

Today it's been a thunderstorm here but right now the sun is shining. Guess, I'll make it for a tour through 
the city.. :)

  Cheers,

        Nils

