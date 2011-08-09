Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1HIFXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 01:23:34 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54817 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288Ab1HIFXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 01:23:33 -0400
Message-ID: <d8d606c9a7ca85a50ef008b7697c84bc.squirrel@xenotime.net>
In-Reply-To: <4E40C28F.6070006@systemfabricworks.com>
References: <4E40C28F.6070006@systemfabricworks.com>
Date: Mon, 8 Aug 2011 22:23:32 -0700
Subject: Re: [patch v3 1/7] crc32: move-to-documentation.diff
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: linux-kernel@vger.kernel.org, linux@horizon.com,
        joakim.tjernlund@transmode.se, fzago@systemfabricworks.com,
        rpearson@systemfabricworks.com, akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 8, 2011 10:15 pm, Bob Pearson wrote:
> Moved a nice but long comment from lib/crc32.c to Documentation/crc32.txt
> where it will more likely get read.
>
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
>
> ---
>  Documentation/crc32.txt |  129
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/crc32.c             |  127
> -----------------------------------------------
>  2 files changed, 129 insertions(+), 127 deletions(-)

Please update Documentation/00-INDEX with this new
file's entry.

Thanks.

-- 
~Randy

