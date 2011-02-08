Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1BHSMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:12:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46873 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1BHSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s77WCbqchprvJDgUP+pxqaKPVEv3FFu0bxEbWleWuLhMEpzIf+JFzbXULk8j3x4Vce
         gX/ppye+uuAcz2dDFKpIc0T5xqFj/6KDCVt+no93LzCgS0TIhqPRe72Ta9lv1g7QI997
         HW1FZ1vxAvaEzMlo/S4qf8hJDr8XAx55L+0pQ=
Date: Tue, 8 Feb 2011 10:12:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Anton Chikin <kverlin@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Chikin <anton.chikin@dataart.com>
Subject: Re: [PATCH] HID: added new driver for Panasonic Elite Panaboard
 UB-T780 and UB-T880
Message-ID: <20110208181204.GF4476@core.coreip.homeip.net>
References: <1297157786-2004-1-git-send-email-kverlin@gmail.com>
 <20110208103923.GA2009@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208103923.GA2009@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:39:23AM +0100, Henrik Rydberg wrote:
> 
> > +int xold = 0, yold = 0;
> 
> static
> 

Not even that. This is an USB device, not a platform one, so it shoudl
be opssible to connect more than one to a box. All state should go into
per-device structure.

This is also does not appear to be a HID driver, really - it does not
use HID infrastucture but does custom parsing.

Calibration - normally we offload this task to userspace (tslib
or other library/driver).

Thanks.

-- 
Dmitry
