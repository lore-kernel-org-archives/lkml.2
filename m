Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1KGQJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:09:20 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36418 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1KGQJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:09:17 -0500
Date: Mon, 7 Nov 2011 11:09:13 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: add blk_finish_plug in error case of writepages.
Message-ID: <20111107160913.GE24234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Kyungmin Park <kmpark@infradead.org>,
	Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
References: <1320472196-1987-1-git-send-email-linkinjeon@gmail.com>
 <CAH9JG2UW0fOQD0V04QsQf7zLEn_v2ScNArajA7YrbXUmN2RXYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2UW0fOQD0V04QsQf7zLEn_v2ScNArajA7YrbXUmN2RXYg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 04:25:52PM +0900, Kyungmin Park wrote:
> It's already fixed after finding the bug by original author.

Hmm, if so I must have checked in the wrong version.  My apologies.

I've applied Namjae Jeon patch as it the blk_finish_plug() does seem
to be missing in the error path.

						- Ted
