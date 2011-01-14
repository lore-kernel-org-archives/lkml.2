Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab1ANQa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:30:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38154 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1ANQaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:30:21 -0500
Date: Fri, 14 Jan 2011 14:30:56 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: David Sterba <dsterba@suse.cz>
Cc: akpm@linux-foundation.org, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita 
	<jprvita@profusion.mobi>
Subject: Re: [PATCH resend] Bluetooth: l2cap: fix misuse of logical
 operation in place of bitop
Message-ID: <20110114163056.GA3736@vigoh>
References: <1295013584-15592-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1295013584-15592-1-git-send-email-dsterba@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

* David Sterba <dsterba@suse.cz> [2011-01-14 14:59:44 +0100]:

> CC: Marcel Holtmann <marcel@holtmann.org>
> CC: "Gustavo F. Padovan" <padovan@profusion.mobi>
> CC: João Paulo Rechi Vita <jprvita@profusion.mobi>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> 
> Andrew, this has not been picked up by maintainers since 27.12., please consider it for -mm.
> 
>  net/bluetooth/l2cap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

I'm taking care of this. Sorry for the delay, I've been away a bit.
Patch is now applied to Bluetooth tree. Thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
