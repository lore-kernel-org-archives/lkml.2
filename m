Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1FIKo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1FIKoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:44:55 -0400
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
From: Dave Airlie <airlied@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Thu, 09 Jun 2011 20:36:51 +1000
In-Reply-To: <20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	 <20110608101515.9478.67943.stgit@localhost.localdomain>
	 <BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	 <20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307615814.5963.2.camel@t60prh>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 09:11 +0100, Alan Cox wrote:
> On Thu, 9 Jun 2011 03:10:03 +0200
> Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
> 
> > Hi Alan
> > 
> > Just a thought. Shouldn't we use the DRM macros for printing debug info?
> 
> Linux has perfectly good printing functions and using them means we can
> use dev_dbg() which supports things like nice runtime switching.

You mean like the drm debug functions runtime switching? that predated
the kernel ones and nobody ever ported :-)

Though if psb wants to be different to other drm drivers it can lead the
way, though it'll be a total nightmare for all the people who follow
documentation on how to debug drm drivers using drm.debug=1,2,4,8. for
various code paths.

Dave.


