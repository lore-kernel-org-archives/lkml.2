Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1C1NZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:25:41 -0400
Received: from twin.jikos.cz ([89.185.236.188]:34544 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1C1NZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:25:39 -0400
Date: Mon, 28 Mar 2011 15:25:28 +0200
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.39
Message-ID: <20110328132527.GM17108@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1301312919-sup-1222@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301312919-sup-1222@think>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Chris, you did not add my sign-of on the unaligned fix I've posted, nor
the tested-by or reported-by. Looking again into the mail, it seems like
some automated-misprocessing picked the first part of the mail altough
there was properly formated patch after '--' marker (and I've verified
this is correct before sending the mail).

Can you please fix that?
Patch reference: https://patchwork.kernel.org/patch/645671/

thanks,
dave
