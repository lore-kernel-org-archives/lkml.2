Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2AJXm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:42:56 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:41965 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab2AJXmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:42:54 -0500
Date: Tue, 10 Jan 2012 18:42:50 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 updates for 3.3
Message-ID: <20120110234250.GC6034@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Rkift-0006hB-04@tytso-glaptop.cam.corp.google.com>
 <CA+55aFwON1TgKhAg6EAkN-D-N87cw9H9UrmyJhzA0G3Rt8TSqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwON1TgKhAg6EAkN-D-N87cw9H9UrmyJhzA0G3Rt8TSqw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 03:15:53PM -0800, Linus Torvalds wrote:
> On Tue, Jan 10, 2012 at 12:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > There is a signed tag ext4_for_linus covering these commits.
> 
> I'm not seeing any such tag. Forgot to push out?

Argh, I always forget to do "git push --tags".  Pushed now...

      	       	      	    - Ted
