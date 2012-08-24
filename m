Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2HXWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:39:00 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46687 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab2HXWi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:38:57 -0400
Date: Fri, 24 Aug 2012 18:38:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        al piszcz <ap@solarrain.com>
Subject: Re: 3.5.1 kernel: Oops + stracktrace + ext4 kernel errors!
Message-ID: <20120824223854.GF5094@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	al piszcz <ap@solarrain.com>
References: <CAO9zADxVjZ7y-wGqV2n89yov_z=XT6zxhHQW4Yp+whe0RO5tuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9zADxVjZ7y-wGqV2n89yov_z=XT6zxhHQW4Yp+whe0RO5tuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:31:44AM -0400, Justin Piszcz wrote:
> Hello,
> 
> Thoughts?
> 
> Saw this when trying to copy files to array with Samba and doing file
> operations:
> 
> [28939.505792] ------------[ cut here ]------------
> [29367.345433] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000028
> [29367.345455] IP: [<ffffffff8116539c>] ext4_ext_remove_space+0x89c/0xc90

Fixed by commit 89a4e48f84 in upstream.  It is scheduled for inclusion
in the a stable kernel series; I believe it should be in 3.5.3.

Regards,

					- Ted
