Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0HaTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:01:37 -0400
Received: from kroah.org ([198.145.64.141]:34419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0HaTBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:01:35 -0400
Date: Tue, 31 Aug 2010 11:56:11 -0700
From: Greg KH <greg@kroah.com>
To: Neil Munro <neilmunro@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 985/985] Staging: RT2860: Fixed All coding style errors
 in rt_linux.h
Message-ID: <20100831185611.GA28510@kroah.com>
References: <1281091790-3721-1-git-send-email-neilmunro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1281091790-3721-1-git-send-email-neilmunro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:49:50AM +0100, Neil Munro wrote:
> Removed all coding style errors from this file the warnings however remain.
> 
> Signed-off-by: Neil Munro <neilmunro@gmail.com>

This patch breaks the build:
drivers/staging/rt2860/sta/rtmp_data.c: In function ‘STASendPackets’:
drivers/staging/rt2860/sta/rtmp_data.c:885:5: error: ‘_p’ undeclared (first use in this function)
drivers/staging/rt2860/sta/rtmp_data.c:885:5: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/rt2860/sta/rtmp_data.c:885:5: error: ‘_status’ undeclared (first use in this function)
drivers/staging/rt2860/sta/rtmp_data.c:885:5: warning: left-hand operand of comma expression has no effect
drivers/staging/rt2860/sta/rtmp_data.c:885:5: error: expected ‘;’ before ‘do’

Please always test your patches before you send them out.

I've dropped this one.

thanks,

greg k-h
