Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237Ab2FHPVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195Ab2FHPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:21:20 -0400
Date: Fri, 8 Jun 2012 11:21:11 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608152111.GA32496@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
References: <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <1339064814.23343.14.camel@twins>
 <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
 <1339140698.23343.26.camel@twins>
 <20120608143829.GD1711@redhat.com>
 <1339167065.2507.38.camel@laptop>
 <20120608150153.GE1711@redhat.com>
 <1339168283.2507.47.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339168283.2507.47.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 05:11:23PM +0200, Peter Zijlstra wrote:
 > On Fri, 2012-06-08 at 11:01 -0400, Dave Jones wrote:
 > > gaah, it's quoted-printable damaged. When I save that in mutt, I get a
 > > file that contains crap like
 > 
 > ok, evolution is no longer able to send plain text..

evolution is a parody of a mail client. Not even a funny one at that.

 >  git can deal with
 > quoted printable, and I have an awk script to decipher it. Still bloody
 > annoying though.
 > 
 > Attached now :/

that works, thanks.

	Dave

