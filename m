Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0HPOTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:19:07 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48262 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754193Ab0HPOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:19:06 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: unable to mount a CD - iso9660 bug?
Date: Mon, 16 Aug 2010 16:18:57 +0200
User-Agent: KMail/1.9.10
Cc: linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201008161438.57103.linux@rainbow-software.org> <20100816132151.GA11369@sig21.net>
In-Reply-To: <20100816132151.GA11369@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008161618.59511.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 August 2010, Johannes Stezenbach wrote:
> On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:
> > I have a CD that came with Samsung printer that Linux cannot mount but
> > works fine in Windows. The CD is physically OK - "dd" made ISO image
> > without any problems. This ISO image is unmountable too. When I force the
> > filesystem to iso9660, it mounts but no files are visible:
>
> Maybe it's a multi-session disk where the first session is
> HFS with Apple software.  Try mounting with -t iso9660 -o session=1.

Still the same - no files. dmesg contains:

ISOFS: Invalid session number or type of track
ISOFS: Invalid session number
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A

-- 
Ondrej Zary
