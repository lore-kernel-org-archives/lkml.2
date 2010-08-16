Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0HPOBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:01:46 -0400
Received: from bar.sig21.net ([80.81.252.164]:59265 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0HPOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:01:44 -0400
X-Greylist: delayed 2383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 10:01:44 EDT
Date: Mon, 16 Aug 2010 15:21:51 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: unable to mount a CD - iso9660 bug?
Message-ID: <20100816132151.GA11369@sig21.net>
References: <201008161438.57103.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008161438.57103.linux@rainbow-software.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.8 (--)
X-Spam-21-Report: No, score=-2.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.295,BAYES_20=-0.74 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:
> I have a CD that came with Samsung printer that Linux cannot mount but works 
> fine in Windows. The CD is physically OK - "dd" made ISO image without any 
> problems. This ISO image is unmountable too. When I force the filesystem to 
> iso9660, it mounts but no files are visible:

Maybe it's a multi-session disk where the first session is
HFS with Apple software.  Try mounting with -t iso9660 -o session=1.

HTH
Johannes
