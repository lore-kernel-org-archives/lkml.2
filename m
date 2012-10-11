Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2JKDGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:06:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54826 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754586Ab2JKDGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:06:13 -0400
Message-ID: <1349924771.2243.16.camel@joe-AO722>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
From: Joe Perches <joe@perches.com>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Date: Wed, 10 Oct 2012 20:06:11 -0700
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22B7B@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	 <1349496603-20775-3-git-send-email-cheiny@synaptics.com>
	 ,<1349525982.2008.86.camel@joe-AO722>
	 <BFABBC009FBA1C43B207B15FD485ABD922C22B7B@USW-MAIL1.synaptics-inc.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 02:49 +0000, Christopher Heiny wrote:
> Joe Perches wrote:
[]
> > > +     list_for_each_entry(entry, &data->rmi_functions.list, list)
> > > +             if (entry->irq_mask)
> > > +                     process_one_interrupt(entry, irq_status,
> > > +                                           data);
> > 
> > style nit, it'd be nicer with braces.
> 
> I agree with you, but checkpatch.pl doesn't. :-(

Sure it does.

$ cat t.c
{
	list_for_each_entry(entry, &data->rmi_functions.list, list) {
		if (entry->irq_mask)
			process_one_interrupt(entry, irq_status, data);
	}
}
$ ./scripts/checkpatch.pl --strict -f t.c
total: 0 errors, 0 warnings, 0 checks, 7 lines checked

t.c has no obvious style problems and is ready for submission.


