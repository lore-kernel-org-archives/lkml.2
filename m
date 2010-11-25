Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0KYW5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 17:57:10 -0500
Received: from build.ihdev.net ([178.63.197.118]:38319 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0KYW5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 17:57:08 -0500
Date: Thu, 25 Nov 2010 17:56:59 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Andrew Hendry <andrew.hendry@gmail.com>,
        Mikhail Ulyanov <ulyanov.mikhail@gmail.com>
Subject: Re: [PATCH 1/1] NET: wan/x25_asy, move lapb_unregister to
 x25_asy_close_tty
Message-ID: <20101125225659.GA13807@build.ihdev.net>
References: <1290642894-4577-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290642894-4577-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:54:54AM +0100, Jiri Slaby wrote:
> We register lapb when tty is created, but unregister it only when the
> device is UP. So move the lapb_unregister to x25_asy_close_tty after
> the device is down.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: Sergey Lapin <slapin@ossfans.org>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
Tested-by: Sergey Lapin <slapin@ossfans.org>
Tested-by: Mikhail Ulyanov <ulyanov.mikhail@gmail.com>
