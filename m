Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab1HUR7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 13:59:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1HUR7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 13:59:33 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Sun, 21 Aug 2011 19:59:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108211959.27207.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 15 sierpnia 2011 o 18:43:22 Justin Piszcz wrote:
> Hello,
> 
> What causes this(?) -- am I out of memory(?) or is this a kernel bug?
> 
> [104147.717815] BUG: soft lockup - CPU#13 stuck for 23s! [kswapd0:934]
> [104147.717820] Modules linked in: dm_mod tcp_diag parport_pc ppdev lp
> parport inet_diag ub pl2303 ftdi_sio snd_usb_audio snd_pcm_oss
> snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd soundcore usbserial cdc_acm nouveau
> serio_raw ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
> i7core_edac edac_core video [104147.717872] CPU 13
> [104147.717874] Modules linked in: dm_mod tcp_diag parport_pc ppdev lp
> parport inet_diag ub pl2303 ftdi_sio snd_usb_audio snd_pcm_oss
> snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd soundcore usbserial cdc_acm nouveau
> serio_raw ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
> i7core_edac edac_core video [104147.717916]
> [104147.717921] Pid: 934, comm: kswapd0 Not tainted 3.0.0 #4 Supermicro
> X8DTH-i/6/iF/6F/X8DTH [104147.717928] RIP: 0010:[<ffffffff81081f71>] 
> [<ffffffff81081f71>] find_get_pages+0x51/0x110 [104147.717940] RSP:
> 0018:ffff880626127ba0  EFLAGS: 00000246
[...]

It's regression? 2.6.39 works OK?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
