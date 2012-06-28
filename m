Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2F1PlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:41:01 -0400
Received: from twin.jikos.cz ([89.185.236.188]:37203 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2F1Pk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:40:59 -0400
Date: Thu, 28 Jun 2012 17:40:37 +0200
From: David Sterba <dave@jikos.cz>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: chris.mason@fusionio.com, dave@jikos.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, ierdnah@gmail.com
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
Message-ID: <20120628154037.GA28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Arnd Hannemann <arnd@arndnet.de>,
	chris.mason@fusionio.com, dave@jikos.cz,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	ierdnah@gmail.com
References: <20120406102232.GH14256@twin.jikos.cz>
 <1334582871-3670-1-git-send-email-arnd@arndnet.de>
 <20120416144233.GC20982@twin.jikos.cz>
 <4FE95B45.8030909@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE95B45.8030909@arndnet.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 08:48:37AM +0200, Arnd Hannemann wrote:
> How show should we proceed to get above mentioned patch
> (or the similar patch from Andrei Popa) merged?

Josef picked the patch into btrfs-next, I see not problem to include it
in next merge window patchset.


david
