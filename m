Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0CUXK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:10:27 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:47397 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab0CUXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u6Q3NLBPrHJNwl1UBP/1UlFSKKCwqQw+zdLrla/ui56i8/B1UYgx142ey4KpIJFg1V
         zOUDnDKi9H9kzPhzrVxXU6jkY4bdPJYWfhhr84TkKOPaAgRgOA6ZECYidYeahFRWvy8v
         PT7+SJ8Ec5sm0iRAppRG7aJfP4NvsEGzMGESg=
MIME-Version: 1.0
In-Reply-To: <201003220007.44981.rjw@sisk.pl>
References: <201003212228.13923.rjw@sisk.pl>
	 <21d7e9971003211536p78792320rf93f9ba5db6c54ff@mail.gmail.com>
	 <201003220007.44981.rjw@sisk.pl>
Date: Mon, 22 Mar 2010 09:10:24 +1000
Message-ID: <21d7e9971003211610h268e10e8oc9ecf06390e421b9@mail.gmail.com>
Subject: Re: Resume problem with radeon+KMS (2.6.34-rc2 and before)
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 9:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 21 March 2010, Dave Airlie wrote:
>> 2010/3/22 Rafael J. Wysocki <rjw@sisk.pl>:
>> > Hi,
>> >
>> > Some time ago I reported a problem with resuming from suspend to RAM on
>> > HP nx6325 with radeon+KMS.
>>
>> Can you post the X.org log file? if you are really using 6.12.4 and
>> not a backport
>> then the userspace driver has no KMS support and it is trashing the system.
>
> Appended below.
>

So your userspace is incompatible with KMS, so I'd suggest trying to
get 6.12.191
or -ati git master,

Dave.
