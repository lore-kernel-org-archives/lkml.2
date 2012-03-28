Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab2C1WTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2C1WS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:18:59 -0400
Date: Wed, 28 Mar 2012 18:18:23 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        keithp@keithp.com, airlied@redhat.com
Subject: Re: Corrupted files after suspend to disk
Message-ID: <20120328221823.GA1897@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	keithp@keithp.com, airlied@redhat.com
References: <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
 <4F574113.8030906@01019freenet.de>
 <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
 <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
 <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz>
 <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com>
 <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
 <4F5DF8F0.5010801@01019freenet.de>
 <20120312214914.GA8628@redhat.com>
 <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 12:12:53AM +0200, Jiri Kosina wrote:
 > On Mon, 12 Mar 2012, Dave Jones wrote:
 > 
 > >  > https://bugzilla.novell.com/show_bug.cgi?id=732908
 > >  > 
 > >  > Following the link, you are able to compare the used chips - maybe there
 > >  > are some equal components?
 > > 
 > > This looks like the i915 corruption problem mentioned in a few other threads.
 > > 
 > > if you compare the hexdump of the good/bad files, you find that the corruption
 > > happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.
 > > 
 > > KeithP clued me in last week that that looks like an ARGB pixel quad, so these
 > > writes are likely 8 pixel strips.
 > 
 > So this keeps happening to me on almost every resume still ... Keith, is 
 > there any way I could help you debug this?

Try this https://bugzilla.kernel.org/attachment.cgi?id=72739

	Dave

