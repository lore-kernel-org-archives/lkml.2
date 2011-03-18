Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1CRXKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:10:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36363 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab1CRXKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ORkioypgYfkTh4vXPOurkD/MPBKx8FN9l4Mzr04tPv8LYdiQtZ5wWvKBgYxGVShAxw
         76npJ1tslUXdZDVqiG+lesIBSfo6fRK+yszR6BuOg3zr7RECo2MUyB6KqPpKLQGuAbWL
         d0jC87BLsNb/2STvUWRJ7zzSXxnHncnNkyBxk=
MIME-Version: 1.0
In-Reply-To: <20110318225016.GB15921@suse.de>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
	<20110318225016.GB15921@suse.de>
Date: Fri, 18 Mar 2011 16:10:10 -0700
X-Google-Sender-Auth: 9KzfBB4jfQVT7aXcRQFfsEDdVNc
Message-ID: <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
        jacek.danecki@intel.com, ed.ciechanowski@intel.com,
        linux-kernel@vger.kernel.org, dmilburn@redhat.com,
        edmund.nadolski@intel.com, Jeff Garzik <jeff@garzik.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 3:50 PM, Greg KH <gregkh@suse.de> wrote:
>> Not sure who looks after efivars.c, but get_maintainer.pl and git shortlog
>> fingered Greg as a likely target.
>
> Yes, that is me.

Sorry Greg, didn't mean to refer to you in the third person.

>
>> We are currently targeting a late merge of the isci driver through the
>> staging tree into 2.6.39.  This is a pre-requisite to be able to use the
>> driver on an efi enabled platform.
>
> You are?  That's news to me, why didn't you ask the staging tree
> maintainer about this?

This was a very recent, two days ago discussion on linux-scsi [1] with
Jeff and Christoph that you should have been copied on...

> I needed all patches in linux-next _before_ the merge window opened to
> be able to accept it.

Yes, I know, and as dmaengine maintainer I also hate being ambushed by
last minute patches, but now I am unfortunately one of those annoying
people on the other side of the coin.

The review has been intermittent until very recently.  Given that
fact, James was understandably not ready to take it into
drivers/scsi/.  So the thought was to leave time for the review to pan
out and then attempt a post -rc1 merge through scsi or staging.

> So, sorry, it will have to wait until .40.
> Please send me the isci driver and I will be glad to queue it up for
> staging for that kernel.

We will submit a revised driver in the next few weeks.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=130022318906252&w=2
