Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2KFJIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2KFJIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:08:12 -0500
Date: Tue, 6 Nov 2012 10:07:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Namjae Jeon <linkinjeon@gmail.com>, eparis@redhat.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>
Subject: Re: NULL pointer dereference at fat_detach
Message-ID: <20121106090751.GB1655@redhat.com>
References: <20121030134449.GA5435@redhat.com>
 <1351632646.1339.72.camel@x61.thuisdomein>
 <87y5in8nys.fsf@devron.myhome.or.jp>
 <1351676454.1339.99.camel@x61.thuisdomein>
 <87ehkf6jxs.fsf@devron.myhome.or.jp>
 <CAKYAXd_m-Vi=oEitg2JpK5MfiBYkL3KbRyQG2mV9--vNUTxaEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_m-Vi=oEitg2JpK5MfiBYkL3KbRyQG2mV9--vNUTxaEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:37:03PM +0900, Namjae Jeon wrote:
> 2012/10/31, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> > Paul Bolle <pebolle@tiscali.nl> writes:
> >
> >> On Wed, 2012-10-31 at 09:49 +0900, OGAWA Hirofumi wrote:
> >>> This bug is known as the inotify bug. I recall I talked about this,
> >>> maybe years ago.
> >>
> >> Would that be this thread: https://lkml.org/lkml/2011/6/10/155 ?
> >
> > Sure, exactly.
> 
> I found related patch.
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=fe9b25d3ee6bdf6f9c9a9ce61d9d3e144bac13ef
> 
> Maybe the above patch should be applied to fix this issue in stable kernel.

First is should go to Linus tree. This commit is more than half year old.
Eric, is there any problem with pull request from your tree?

Stanislaw
