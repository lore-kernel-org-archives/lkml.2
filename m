Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0LGVR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:17:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54823 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0LGVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:17:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wdgAiigYIL0m61CJrZdaDLTy08tsy0n6dekGMuYjS+0/Vw194oRbolYvjIjdFP2Sqe
         e1sXFP4PDXjhvD5FwoDsTl2VWQ6oqaNSpFVM9rS41cwucgbjHQmQvLAnt+lciTFF6I5F
         1fnbg/FwyRANvnzlOkHlfIk2Dsbv0hgIhOOjE=
MIME-Version: 1.0
In-Reply-To: <4CFE9FF6.2080800@euromail.se>
References: <1291722357-22820-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1012071553100.14806@pobox.suse.cz>
	<4CFE934D.4040309@euromail.se>
	<AANLkTik=A5xc2RexWqDMvumFqbA6HtzynWmP=Fz6+SvE@mail.gmail.com>
	<4CFE9FF6.2080800@euromail.se>
Date: Tue, 7 Dec 2010 13:17:23 -0800
Message-ID: <AANLkTikzDbsw8Umrwjb4ij89NcNp3y41gP9kZ_zk2JPE@mail.gmail.com>
Subject: Re: [PATCH v3] input: mt: Move tracking and pointer emulation to input-mt
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 12:58 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
>> I do see an issue when pen coming in prox while fingers were on the
>> tablet. Fingers up events are missing.
>>
>> Since it is unrelated to this patch, I'll submit another patch as a
>> bug fix later.
>
> Actually, I believe it is correct as is. One could always argue (and I did at
> the time of that change) whether touch up is the right thing to do in the
> proximity of the pen, but that is what the code does now. As proof, check how
> input_mt_report_slot_state() is used.

I see.  input_mt_report_slot_state does take care of the case. That
unifies the code a lot more than I expected. Thank you.

Ping
