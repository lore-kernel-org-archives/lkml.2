Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2GMRuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2GMRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:50:36 -0400
Date: Fri, 13 Jul 2012 13:50:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120713175030.GA8911@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>
References: <20120713173536.GB25432@redhat.com>
 <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:47:43AM -0700, Linus Torvalds wrote:
 > On Fri, Jul 13, 2012 at 10:35 AM, Dave Jones <davej@redhat.com> wrote:
 > > This can be trivially triggered from userspace by passing in something unexpected.
 > 
 > Argh. It looks like it would be harmless (apart from the noise),
 > except we hold file_lock_lock. Which turns the BUG_ON() into not just
 > "noise and kill the process", but "noise and kill the process and
 > leave a nasty lock held".

Yeah, box wedged shortly afterwards. Not cool.

 > This seems to go back to 3.2, so stable should be cc'd, no?

yeah, definitly. my bad.

	Dave

