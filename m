Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0EUDfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 23:35:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56051 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0EUDfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 23:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KYxNM7H4ZMPTgq3KWVl6VXZKOxCpNsHyKHA1xTlCQB7VFB6Sez2AZt8EZfQwUJMP15
         vRfU1ChpazPa+0KTl1NV517S7WvrPp8gjtwTuyHdIcA2eDkoD4vFcOm/VyiP3bX8NCjU
         pUMhBpMW5fwouv4VyKCfkjdVIcE0kDy+Fh6zI=
MIME-Version: 1.0
In-Reply-To: <4BF5BC48.6000809@euromail.se>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4E00A.30206@euromail.se>
	 <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
	 <4BF5BC48.6000809@euromail.se>
Date: Thu, 20 May 2010 20:35:42 -0700
Message-ID: <AANLkTikwc2fEL_oTzpLtEBM-z8CPymqzIxVoebanT3ih@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 3:48 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> I need double check with you although I think I know the answer. From
>> your explanation and examples so far, I see MT_SLOT is only associated
>> with one (x,y). Is this true?  If yes, can we eliminate the
>> requirement for TRACKING_ID? If you think the requirement is
>> necessary, can you give me an example where missing the TRACKING_ID
>> would bring issue or confusion?
>
> Yes, each slot can only be associated with one (x, y) pair. No, we cannot
> disregard the tracking id. A slot tracks a single contact for its entire
> lifetime, during which the tracking id serves no purpose, but the slot cannot
> tell us when the contact is replaced by a new one. This information is carried
> by the tracking id.

Ok, I've made enough noise in this thread. If we change SYN_MT_SLOT to
ABS_MT_SLOT_ID (or something starting with ABS_ of your choice), I
have no more questions.

You can put my reviewed-by in the patch if that counts for anything:

Reviewed-by: Ping Cheng <pingc@wacom.com>

Ping
