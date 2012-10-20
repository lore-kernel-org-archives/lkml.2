Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2JTQ2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:28:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2JTQ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:28:04 -0400
Date: Sat, 20 Oct 2012 18:27:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting a
 particular website
Message-ID: <20121020162759.GA12551@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Artem S. Tashkinov" <t.artem@lycos.com>,
	linux-kernel@vger.kernel.org
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:06:55PM +0000, Artem S. Tashkinov wrote:
> Hello,
> 
> I'm running vanilla Linux 3.6.2 x86 on top of CentOS 6.3 userspace.
> 
> Every time when I enter the chat roulette website, right click anywhere and choose "Settings",
>  my PC crashes (with or without NVIDIA drivers running, it happens even when I'm running Vesa).
> 
> Web browser: google-chrome-stable-22.0.1229.94-161065.i386.rpm
> OS: Linux 3.6.2 vanilla x86
> CPU: Intel Core i5 2500 (non-overclocked)
> GCC: 4.7.2 vanilla
> 
> The latest crash:
> 
> Oct 20 07:15:22 localhost kernel: [  224.293756] Modules linked in: pppoe pppox ppp_synctty ppp_async crc_ccitt ppp_generic slhc ipv6 nf_conntrack_ftp nf_conntrack_netbios_ns nf_conntrack_broadcast xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_pkttype ipt_ULOG xt_owner xt_multiport iptable_filter ip_tables x_tables w83627ehf adt7475 hwmon_vid vboxpci(O) 
> vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc fuse hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi uvcvideo videobuf2_core videodev 
> videobuf2_vmalloc videobuf2_memops usbhid hid sr_mod cdrom coretemp aesni_intel ablk_helper cryptd aes_i586 aes_generic microcode agpgart pcspkr snd_hda_codec_realtek 
> snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd snd_page_alloc i2c_i801 sg xhci_hcd fan ehci_hcd e1000e evdev [last unloaded: nvidia]
> 
> Oct 20 07:15:22 localhost kernel: [  224.293811] Pid: 2569, comm: console-kit-dae Tainted: P           O 3.6.2-ic #2

Yeah, your kernel is tainted with a proprietary module (vbox*, etc). Can
you reproduce your corruptions (this is what it looks like) without that
module?

Thanks.

-- 
Regards/Gruss,
    Boris.
