Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0LTOp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:45:58 -0500
Received: from mx.mylinuxtime.de ([80.190.48.209]:47526 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab0LTOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:45:56 -0500
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 09:45:56 EST
X-Spam-ASN: 
Date: Mon, 20 Dec 2010 15:36:50 +0100
From: Christian Hesse <mail@eworm.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
        thunar-dev@xfce.org
Subject: Re: Thunar crashes kernel
Message-ID: <20101220153650.763c3a8b@leda.vpn.lugor.de>
In-Reply-To: <1292646773.7406.19.camel@marge.simson.net>
References: <20101218005526.177e1617@leda.vpn.lugor.de>
	<1292646773.7406.19.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
X-Face: "d>6C<o20Jq\3Dm/WqbiN5&YtzNv;d*d[)V}&k1VAz`/JytY^Ef[$%i1\!(A.0a_hG'3Nty
 ot3sMM"=U}KYBreL=)7G8=&xl+o2$1>I.p%5<MZw"5]g7gFViYNea7?o^`RX/[7Pa5%_I[B3X_VF/V
 ojXH:AWqi3oybH"8e7ZIp1z\E[XV~dseyX>Rxe<dL
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Envelope-From: <mail@eworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 05:32:53 +0100 Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2010-12-18 at 00:55 +0100, Christian Hesse wrote:
> > Hallo everybody,
> > 
> > I'm running kernel 2.6.36.2 from Arch Linux, patched with autogroup. It
> > ran perfectly stable so far, now I found a way to crash it:
> 
> You're running a buggy version of the patch.  If you want autogroup in
> 36.2, you'll want what was integrated into tip, plus a fix to that.
> 
> Attached is a quilt tarball of what I've got plugged into 36.2 here if
> you want to try it.

That fixed it for me.
Thanks a lot!
-- 
Regards,
Chris
