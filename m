Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1HRGwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:52:21 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:41535 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1HRGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:52:18 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 4/6] Input: elantech - work around EC buffer
In-Reply-To: <20110818063918.GD10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw> <20110818063918.GD10093@core.coreip.homeip.net>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 14:54:36 +0800
Message-ID: <87zkj72or7.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 17 Aug 2011 23:39:18 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Aug 18, 2011 at 09:57:07AM +0800, JJ Ding wrote:
> > With some EC chips, when we resync due to bad packets, those bad bytes would
> > still remain in EC's buffer area. That makes us always get bad data back,
> > no matter what.
> > 
> > So shift packet for 1 byte when encounter bad packet, until we get rid of those
> > bytes.
> 
> If we want to do this I think it should be done in psmouse core.
> 
> Thanks.
OK. That sounds more appropriate.
I will remove this patch from the series.

Thanks, 

jj

> 
> -- 
> Dmitry
