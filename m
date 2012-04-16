Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2DPOmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:42:55 -0400
Received: from twin.jikos.cz ([89.185.236.188]:37966 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab2DPOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:42:54 -0400
Date: Mon, 16 Apr 2012 16:42:35 +0200
From: David Sterba <dave@jikos.cz>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: dave@jikos.cz, chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
Message-ID: <20120416144233.GC20982@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Arnd Hannemann <arnd@arndnet.de>, dave@jikos.cz,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120406102232.GH14256@twin.jikos.cz>
 <1334582871-3670-1-git-send-email-arnd@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334582871-3670-1-git-send-email-arnd@arndnet.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 03:27:51PM +0200, Arnd Hannemann wrote:
> Btrfs allows to turn on compression on a mounted and used filesystem
> by issuing mount -o remount,compress=lzo.
> This patch allows to turn compression off again
> while the filesystem is mounted. As suggested by David Sterba
> if the compress-force option was set, it is implicitly cleared
> if compression is turned off.
> 
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>

Tested-by: David Sterba <dsterba@suse.cz>

worked perfectly, remounting back and forth with compress=lzo =no
-force=lzo etc, checked output via 'mount'.


david
