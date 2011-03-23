Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1CWOeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1CWOeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:34:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Any USB gadget AIO interface users?
References: <20110322171251.GA4455@xanatos>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Mar 2011 10:34:08 -0400
In-Reply-To: <20110322171251.GA4455@xanatos> (Sarah Sharp's message of "Tue,
	22 Mar 2011 10:12:51 -0700")
Message-ID: <x49vcz9c3dr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:

> Has anyone successfully used the asynchronous I/O gadgetfs interface
> before?  Specifically, has anyone used it for high-bandwidth isochronous
> traffic?
>
> I ask because I remember discovering about four years ago that there
> were several brain-twisty bugs in the in-kernel asynchronous I/O layer
> that gadgetfs uses.

Weren't they addressed?  And are you looking to use the gadgetfs aio
interface now, or are you looking to get rid of it?  In other words,
what's the real motivation behind the question?

> The AIO core also seemed to be largely unmaintained.  Is this still
> true?

Surely you should at least cc the aio list when asking such a question!
Anyway, the aio core is maintained by several folks, but nobody is doing
active development in that area, to my knowledge.

Cheers,
Jeff
