Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2LFD2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:28:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2LFD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:28:05 -0500
Date: Thu, 6 Dec 2012 01:27:59 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 019/270] jbd: Fix assertion failure in commit code due to
 lacking transaction credits
Message-ID: <20121206032758.GE9983@herton-Z68MA-D2H-B3>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-20-git-send-email-herton.krzesinski@canonical.com>
 <20121205120240.GA5706@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205120240.GA5706@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 01:02:41PM +0100, Jan Kara wrote:
> On Mon 26-11-12 14:55:09, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
>   Note that this fix causes another problem which is fixed by
> 25389bb207987b5774182f763b9fb65ff08761c8 upstream.
> 									Honza

Thanks, I'm going to queue this one for next 3.5.y.z release.

> 
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit 09e05d4805e6c524c1af74e524e5d0528bb3fef3 upstream.
> > 

-- 
[]'s
Herton
