Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1B0Xdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:33:47 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45430 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1B0Xdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:33:37 -0500
Date: Sun, 27 Feb 2011 17:38:27 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 12/17]fs:jbd Remove one to many n's in a word.
Message-ID: <20110227223826.GK2924@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
 <1298781250-2718-13-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298781250-2718-13-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 08:34:05PM -0800, Justin P. Mattock wrote:
> The Patch below removes one to many "n's" in a word.. 
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org> 
> CC: Jan Kara <jack@suse.cz> 
> CC: linux-ext4@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
