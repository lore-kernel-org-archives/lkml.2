Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353Ab0KQTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:01:32 -0500
Received: from thunk.org ([69.25.196.29]:55161 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040Ab0KQTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:01:31 -0500
Date: Wed, 17 Nov 2010 14:01:25 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dan Carpenter <error27@gmail.com>, Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ext4: missing unlock in ext4_clear_request_list()
Message-ID: <20101117190125.GJ3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dan Carpenter <error27@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101117050732.GB31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117050732.GB31724@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 08:07:32AM +0300, Dan Carpenter wrote:
> If the the li_request_list was empty then it returned with the lock
> held.  Instead of adding a "goto unlock" I just removed that special
> case and let it go past the empty list_for_each_safe().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Nice catch.  Thanks, I've grabbed this and put it into the ext4 patch
queue and will be pushing it to Linus ASAP.

					- Ted
