Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab0LNSku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:40:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61219 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab0LNSks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:40:48 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.87.10]
In-Reply-To: <20101214170656.GA3832@kroah.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com> <20101214170656.GA3832@kroah.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 14 Dec 2010 20:40:28 +0200
Message-ID: <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: Greg KH <greg@kroah.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 7:06 PM, Greg KH <greg@kroah.com> wrote:
>> Can you please have a look and say if this looks OK ?
>
> Look at what, I don't see a patch here.

Here's the complete patchset:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg39833.html

If you prefer, I can resubmit.

>
> I've seen a lot of discussion about this, are all of the review comments
> now addressed?

Yes, all comments were addressed in this v3 iteration, and this thread
has been idle for about 10 days.

>  Like the most important one, why is this generic code if
>  it's only for one specific platform?

We started out with an omap-specific driver, but Tony preferred that we
make this a platform-agnostic framework, in order to keep the IPC drivers that
will use it generic, and assuming that more users will show up for
such framework.

To me it sounds reasonable, but both ways (framework / omap-specific
driver) will work for us just fine, and I can switch back to a misc
driver if this is preferred.

The complete discussion of v1 is at:
http://comments.gmane.org/gmane.linux.kernel/1049802

We also discussed this at v2 of the patches with David, see the
complete discussion at:
http://comments.gmane.org/gmane.linux.kernel/1067016

Thanks,
Ohad.

>
> thanks,
>
> greg k-h
>
