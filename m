Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KLV0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:26:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2KLV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:26:14 -0500
Date: Mon, 12 Nov 2012 19:26:08 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [ANNOUNCE] Extended stable support for Linux 3.5
 (linux-3.5.y-ext.z)
Message-ID: <20121112212607.GG3342@herton-Z68MA-D2H-B3>
References: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 12:15:04PM -0200, Herton Ronaldo Krzesinski wrote:
> I plan to do a similar workflow as to what is done today with current
> stable releases. I'll send email notifications to everyone involved in
> each patch when it's added to 3.5 queue, and post the patches for review
> for each release cycle. Just versioning will be slightly different,
> every version is planned to be tagged as v3.5.7-ext.<release number>,
> ext meaning extended, 3.5.7 was the last stable kernel in 3.5 kernel and
> should remain constant.

Just a note, the tagging probaly will be different from what I said here,
in the format v3.5.7u<release number>, simpler format. Anything changing
I'll keep updated in future announcements while releasing the patches.

-- 
[]'s
Herton
