Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1JXUe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:34:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38528 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JXUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:34:57 -0400
Date: Mon, 24 Oct 2011 21:33:39 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Einon <mark.einon@gmail.com>, Greg KH <greg@kroah.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 2/6] et131x: uintxy_t removal.
Message-ID: <20111024203338.GD3851@msilap.einon>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
 <20111023093651.GA22285@kroah.com>
 <20111023094231.GA3409@msilap.einon>
 <20111023171119.GB28657@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023171119.GB28657@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:11:19PM +0200, Francois Romieu wrote:
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

I don't believe this is strictly necessary, as uintxy_ts are allowed, but ok - at least it makes the file homogeneous.
Acked-by: Mark Einon <mark.einon@gmail.com>
