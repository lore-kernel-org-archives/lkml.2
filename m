Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0HQKIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:08:48 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35436 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755617Ab0HQKIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:08:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Tao Ma <tao.ma@oracle.com>
Subject: Re: unable to mount a CD - iso9660 bug?
Date: Tue, 17 Aug 2010 12:08:40 +0200
User-Agent: KMail/1.9.10
Cc: Johannes Stezenbach <js@sig21.net>, linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201008161438.57103.linux@rainbow-software.org> <201008161850.08442.linux@rainbow-software.org> <4C6A511F.5090407@oracle.com>
In-Reply-To: <4C6A511F.5090407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008171208.42512.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Tao Ma wrote:
> Hi Ondrej
>
> On 08/17/2010 12:50 AM, Ondrej Zary wrote:
> > On Monday 16 August 2010 16:18:57 Ondrej Zary wrote:
> >> On Monday 16 August 2010, Johannes Stezenbach wrote:
> >>> On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:
> >>>> I have a CD that came with Samsung printer that Linux cannot mount but
> >>>> works fine in Windows. The CD is physically OK - "dd" made ISO image
> >>>> without any problems. This ISO image is unmountable too. When I force
> >>>> the filesystem to iso9660, it mounts but no files are visible:
> >>>
> >>> Maybe it's a multi-session disk where the first session is
> >>> HFS with Apple software.  Try mounting with -t iso9660 -o session=1.
> >>
> >> Still the same - no files. dmesg contains:
> >>
> >> ISOFS: Invalid session number or type of track
> >> ISOFS: Invalid session number
> >> ISO 9660 Extensions: Microsoft Joliet Level 3
> >> ISO 9660 Extensions: RRIP_1991A
> >
> > Here's the compressed ISO file if anyone wants to examine it:
> > http://www.rainbow-software.org/linux_files/samsung-bad.rar
>
> what is your kernel version? I can mount it successfully in my el5 box
> with kernel 2.6.35+.

I have 2.6.35. Also tried it on another two machines with Debian Squeeze 
2.6.32 and Lenny 2.6.26 with the same result (no files visible when mounted).


-- 
Ondrej Zary
