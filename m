Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab1CIKRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:17:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47317 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab1CIKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Q6H+NNHOenO+rLdaF4VwMXbn04kfCzkyiWaUATc1X+IutnQv9KdLcBwJ+2An+LshxG
         3Fv54Q8DTCumvfcobIedA9iUGtZKs1oAuuSQThcAkMI20mNPuO75flkIYNfebOMUCtOy
         UoJ1juLFRjbmUpauEY8Lwgv46H1x7OxGNalAM=
MIME-Version: 1.0
In-Reply-To: <20110309094748.GB3980@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
	<1299601979-4871-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110309084645.GB3569@polaris.bitmath.org>
	<AANLkTi=LHwdvpJOyeVqHrpFjikr5=uKsaa_T3LKgXtDP@mail.gmail.com>
	<20110309094748.GB3980@polaris.bitmath.org>
Date: Wed, 9 Mar 2011 11:17:38 +0100
X-Google-Sender-Auth: cXrZdJcbOCrl-DofxoVKgEYISVw
Message-ID: <AANLkTina5AEZ1sKvGb16-Ny11ps0=Ad9aoDqitFaL_Nw@mail.gmail.com>
Subject: Re: [PATCH 3/4] hid-multitouch: migrate 3M PCT touch screens to the
 unified driver.
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 10:47, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Mar 09, 2011 at 10:13:55AM +0100, Benjamin Tissoires wrote:
>> Hi Henrik
>>
>> On Wed, Mar 9, 2011 at 09:46, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Hi Benjamin,
>> >
>> > On Tue, Mar 08, 2011 at 05:32:58PM +0100, Benjamin Tissoires wrote:
>> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> >> ---
>> >
>> > Semms this patch is missing a commit message.
>>
>> You can copy/paste this point to the other patches as well.
>>
>> How about:
>> "3M PCT touch screens can be handled by the unified driver. This will
>> ease future evolution. So, just move it."
>>
>> Then I'll copy/paste for the others.
>
> I bet every driver merge has its own considerations that deserve
> comment. A good commit message gives an introduction to the code
> change and gives some context to the reader. Richard made a nice one
> for the egalax driver.
>

Now that We have to introduce .sn_width / .sn_height for 3M, this need
indeed a better commit message.

Cheers,
Benjamin
