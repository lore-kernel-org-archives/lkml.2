Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1AGTMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:12:24 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52089 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1AGTMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=P4kt0d2PBW9yXPI3wqwwUC12qOXKGcZ59R9HK56W1uSwkVcG3mtkA0qM4tEiB1KUsK
         /fTh5L/FXNtP93XTBrW4Dcd930XpZM/pohTJXKpOKFa0tGLB2LU6V4YoWPeZsShKUfgW
         qJpbIyCfNG8LHqqUpmAC2JkJC/6FrKqM3H3Rw=
MIME-Version: 1.0
In-Reply-To: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
Date: Fri, 7 Jan 2011 20:12:21 +0100
X-Google-Sender-Auth: _Q2uCirkDYzLEDHKbIbv5ooqpXU
Message-ID: <AANLkTikxWv+zn1MdXAGFSZU=hNfF4OHnK7pCk6DgdKSg@mail.gmail.com>
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch unification
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention that I keep the flag RFC as I'm waiting for more
tests in the begining of the next week (only Cypress has been tested
with the last release).

Cheers,
Benjamin

On Fri, Jan 7, 2011 at 7:42 PM, Benjamin Tissoires
<benjamin.tissoires@enac.fr> wrote:
> Hi,
>
> here is the v3.
>
> all changes are coming from the mails with Henrik:
>
> - restricted to new drivers only
> - delete mt_buffer struct
> - replace/adapt prev_valid in favor of seen_in_this_frame
> - integrated fuzz
> - introduce MT_QUIRKS
> - other small fixes
>
> Cheers,
> Benjamin
>
>
