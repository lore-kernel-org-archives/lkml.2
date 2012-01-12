Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2ALQpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:45:45 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:33419 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2ALQpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:45:41 -0500
Date: Thu, 12 Jan 2012 11:45:32 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 3.3-rc1
Message-ID: <20120112164532.GB6626@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120112065144.GA24051@linux-sh.org>
 <CA+55aFzTJe_VwDxiBKyB3dNCJfm=HXxib4Y4fGihhoBFvXiOTw@mail.gmail.com>
 <CA+55aFxjHamzRteKAXLGuBt4LH-ZkJ+PJxZS5kWST-umhK8Zow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxjHamzRteKAXLGuBt4LH-ZkJ+PJxZS5kWST-umhK8Zow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:35:32PM -0800, Linus Torvalds wrote:
> 
> Looking good. Pushed out, and if you have current git and want to see
> what it all looks like when I pull your signed tag, you can use "git
> log --show-signature" to see it revalidate your signature ;)

Public service announcement --- note that you need to update to git
1.7.9-rc0 or lateer for git log --show-signature to work.

	     	    	    			    - Ted
