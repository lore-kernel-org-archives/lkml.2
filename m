Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2D3FG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:06:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65449 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2D3FGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:06:55 -0400
Date: Sun, 29 Apr 2012 21:28:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Ali Bahar <ali@internetDog.org>,
        Michael Fiedler <michael.fiedler@informatik.stud.uni-erlangen.de>,
        Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <error27@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/rtl8712: Remove version.h includes
Message-ID: <20120430012838.GA12956@kroah.com>
References: <1335693823-8673-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335693823-8673-1-git-send-email-josephdanielwalter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 04:03:43PM +0600, joseph daniel wrote:
> there are version.h includes that are not needed , reported by make versioncheck
> files:
> 1. drivers/staging/rtl8712/osdep_service.h
> 2. drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> 
> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>

This is already fixed up in linux-next, so I can't apply the patch
again, sorry :(

