Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2HMSWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:22:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2HMSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:21:59 -0400
Date: Mon, 13 Aug 2012 15:21:54 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug fixes/cleanups for floppy driver (v2)
Message-ID: <20120813182152.GA3223@herton-Z68MA-D2H-B3>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:16:21PM -0300, Herton Ronaldo Krzesinski wrote:
> Following this are fixes for bugs I noticed on floppy driver, and some
> extra cleanups.
> 
> v2: separate fixes, and incorporate suggestions by Vivek Goyal.
>     also I splitted the cleanups from fixes.
> v3: remove dr, also this possibly makes error handling more readable
>     (suggested by by Vivek Goyal), incorporate acks.

Subject obviously should have been "... (v3)"

-- 
[]'s
Herton
