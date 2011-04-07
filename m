Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1DGLd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:33:57 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:36022 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1DGLd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:33:56 -0400
Date: Thu, 7 Apr 2011 13:33:47 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Dave Airlie <airlied@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110407113347.GA2237@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Dave,

sorry, in my previous message I forgot the strace
output, which is an inifinite loop of the following:

--- SIGALRM (Alarm clock) @ 0 (0) ---
sigreturn()                             = ? (mask now [])
ioctl(7, 0xc0286429, 0xffdf9bb8)        = -1 EBUSY (Device or resource busy)
--- SIGALRM (Alarm clock) @ 0 (0) ---
sigreturn()                             = ? (mask now [])
ioctl(7, 0xc0286429, 0xffdf9bb8)        = -1 EBUSY (Device or resource busy)

Note: fd 7 is /dev/dri/card0.

	Regards,
	Gabriel
