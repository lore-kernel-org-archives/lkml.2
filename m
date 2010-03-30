Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab0C3Usk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:48:40 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63956 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0C3Use convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JZP/PnN0a0hEZiPzBYBjX8DLADyR0cNp8oGKVg17tg7iiqebQ1AoNxbDA+K3bvsdkT
         rGHl7yzOumZ2RaWaNiYpXsC0N3VzBJNZfA5NIyzZuimFqikzgDxWCxmmAvJ+GO4EShDO
         qoARyTUKfvSjkSfZbWhi2mD+IlBJ0YYaPAfYQ=
MIME-Version: 1.0
In-Reply-To: <20100330200842.GF1693@kroah.com>
References: <12698953011038@site> <1269900575.2446.3425.camel@rchatre-DESK>
	 <20100329222404.GA10927@suse.de> <4BB1A532.6030502@canonical.com>
	 <20100330200842.GF1693@kroah.com>
Date: Tue, 30 Mar 2010 22:48:32 +0200
Message-ID: <6cf6b73e1003301348u5ed9dabap8690db5ca8a8d293@mail.gmail.com>
Subject: Re: [stable] patch iwlwifi-silence-tfds_in_queue-message.patch added 
	to 2.6.32-stable tree
From: Adel Gadllah <adel.gadllah@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
       "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
       reinette chatre <reinette.chatre@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Greg KH <greg@kroah.com>:
> On Tue, Mar 30, 2010 at 09:16:02AM +0200, Stefan Bader wrote:
>> Greg KH wrote:
>> > On Mon, Mar 29, 2010 at 03:09:35PM -0700, reinette chatre wrote:
>> >> Hi,
>> >>
>> >> On Mon, 2010-03-29 at 13:41 -0700, gregkh@suse.de wrote:
>> >>> This is a note to let you know that we have just queued up the patch titled
>> >>>
>> >>>     Subject: iwlwifi: Silence tfds_in_queue message
>> >>>
>> >>> to the 2.6.32-stable tree.
>> >> [...]
>> >>
>> >> Please note that this patch is really just masking a problem introduced
>> >> by a 2.6.32 backported patch. The real fix is
>> >> https://patchwork.kernel.org/patch/86722/ which should be included in
>> >> 2.6.32.
>> >
>> > What is the git commit id for that patch?  patchwork links don't help me
>> > at all.
>>
>> There isn't one. The main problem only exists in 2.6.32.y
>> because the final hunk missed to remove the nfreed++ from
>> ouside the if.
>>
>> Introduced by backport of in 2.6.32.y
>>
>> commit a120e912eb51e347f36c71b60a1d13af74d30e83
>> Author: Stanislaw Gruszka <sgruszka@redhat.com>
>> Date:   Fri Feb 19 15:47:33 2010 -0800
>>
>>     iwlwifi: sanity check before counting number of tfds can be free
>
> So, what exactly should I be doing here for the .32 stable queue?

Apply the patch that fixes the mess (i.e the one Reinette linked to)
;), whether this patch (the one you are about to push) goes in or not
does not matter much (i.e having it won't hurt, but the fix for the
real problem should go in).

Adel
