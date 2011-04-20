Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1DTXK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:10:29 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42745 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752737Ab1DTXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:10:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=o+ROH0/fW1KTnQ8C1wvvXaCHCUhI37SUd7Jx9n9ed5kQh3932H89KRBfB7gNCxf94VQtQQ6Jt9J6k0cU+EyBQtIqndtlIPwVponmDKfQtwLheVj31XvhFahHU7Em2V1v;
Date: Wed, 20 Apr 2011 16:10:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
Message-Id: <20110420161025.88299c36.rdunlap@xenotime.net>
In-Reply-To: <1303340700.13457.88.camel@localhost>
References: <james_p_freyensee@linux.intel.com>
	<1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
	<20110419161509.21b678d3.rdunlap@xenotime.net>
	<1303340700.13457.88.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 16:05:00 -0700 J Freyensee wrote:

> On Tue, 2011-04-19 at 16:15 -0700, Randy Dunlap wrote:
> 
> A couple more comments below.
> 
> > On Tue, 19 Apr 2011 15:58:08 -0700 james_p_freyensee@linux.intel.com wrote:


> > > + * @max_IDS: The max amount of available write IDs to use.
> > > + * @baseID:  The starting SW channel ID, based on the Intel
> > > + *           PTI arch.
> > > + *
> > > + * @return: pti_masterchannel struct containing master, channel ID address,
> > 
> > No '@' on "return".
> 
> Why no '@' on 'return' when just by doing a 'grep -Ri "@return" drivers/
> | wc -l' I count 369 examples of '@return' being used already in the
> kernel?  It looks like an acceptable format to me.

It's not.  See Documentation/kernel-doc-nano-HOWTO.txt.
'@' goes on function parameters (or struct members).
Not on return values.  Those other places should be fixed, but
it's just not a high priority thing to do.


> > > + * or 0 for error.
> > > + *
> > > + * Each bit in the arrays ia_app and ia_os correspond to a master and
> > > + * channel id. The bit is one if the id is taken and 0 if free. For
> > > + * every master there are 128 channel id's.
> > > + */
> > > +static struct pti_masterchannel *getID(u8 *IDarray, int max_IDS, int baseID)
> > > +{


> > > +/**
> > > + * pti_request_masterchannel() - Kernel API function used to allocate
> > > + *                                a master, channel ID address to write to
> > > + *                                PTI HW.
> > > + * @type: 0- request Application  master, channel aperture ID write address.
> > > + *        1- request OS master, channel aperture ID write address.
> > > + *        2- request Modem master, channel aperture ID write
> > > + *           address.
> > > + *        Other values, error.
> > > + * @return: pti_masterchannel struct or 0 for error.
> > 
> > No '@' on "return".
> 
> Same reason here.

Same answer here.



> > > + *
> > > + * @return int : Success = 0, otherwise fail.
> > 
> > No '@' on "return".
> 
> Same explanation as above.

Same reply also.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
