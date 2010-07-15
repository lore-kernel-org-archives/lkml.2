Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab0GOAYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:24:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57222 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab0GOAYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tdRtOXeN3aRCa0Y0qgRMVz4uZIpCVbIDBzZ43HJRmb9DvpmjqrcvGblmvzBP7Dykdy
         JE4v+ddmNPsdPTVydU3ijSVEVAJJy1mr23+2r8XKGFQR7rXjXc728bhaIARkCoB1QQfV
         gCD84/U3YKIT7zfcaJ5I7w0Ettpkoyw4HigMA=
MIME-Version: 1.0
In-Reply-To: <20100714163852.b3c09930.akpm@linux-foundation.org>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
Date: Thu, 15 Jul 2010 10:24:18 +1000
Message-ID: <AANLkTinIy1z7226W0ylNfDdHXBp16Wt7aYBKQYY1o5t9@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
From: Dave Airlie <airlied@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 9:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 9 Jul 2010 11:54:50 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
>> This is no longer needed by any userspace tools, so it's safe to
>> remove.

Also still used for booting mainline kernels on RHEL5 userspaces.

Live with your mistakes guys, don't try and bury them.

Dave.
