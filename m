Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1AMOpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:45:23 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:57794 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1AMOpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:45:21 -0500
Date: Thu, 13 Jan 2011 15:45:12 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20110113144512.GH3486@excalibur.local>
References: <4D2C52E3.2020702@example.com>
 <20110111131423.GA17312@hack>
 <4D2DB674.4030900@example.com>
 <4D2F0C64.3010403@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2F0C64.3010403@example.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: Error in linux-2.6.37-git5 in btrfs in ctree.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Thu, 2011-01-13 at 15:29, Piotr Hosowicz wrote:
> On 12.01.2011 15:11, Piotr Hosowicz wrote:
> >On 11.01.2011 14:14, Américo Wang wrote:
> >>On Tue, Jan 11, 2011 at 01:53:55PM +0100, Piotr Hosowicz wrote:
> >>>(I send again because my previous message wasn't delivered.)
> >>>
> >>>Hello,
> >>>
> >>>There is an error in here:
> >>>
> >>>In file included from fs/btrfs/ctree.c:21:
> >>>fs/btrfs/ctree.h:1003: error: field ‘super_kobj’ has incomplete type
> >>>fs/btrfs/ctree.h:1074: error: field ‘root_kobj’ has incomplete type
> >>>
> >>>Kernel fails to build. linux-2.6.37-git5
> >
> >I see that it's the same in Linus GIT tree, I didn't fail to build,
> >because I corrected the same way first, it's building now. Should it be
> >like that?
> >
> 
> The situation is exactly the same today. What to do? I don't need
> btrfs, but must do some correction s I do not understand exactly. I
> don't like it.

I'm waiting for feedback on the patch I sent in for this. linux-btrfs and Chris
had beend added but no reply so far. Not sure if there is a hotpath for build
fixes or if maintainer pick them up as usual.

regards
Stefan Schmidt
