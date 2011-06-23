Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab1FWSOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:14:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab1FWSOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MVwEQOeIGhb+ock9+4qbo2M2RPzeiM+xZTPsX6ILxwqA2JAhbTILuI1WiX6opGE8BX
         BIuC5q1QhQZQWa6bQ023sbfOThLNIJMWLyEo5w2Izgg+kcatA4+zatzDLr36JQXoYSfk
         5gbgmTTsbz4PDDGL9x1OQU2rv/ZMRJ0h7Rg9I=
MIME-Version: 1.0
In-Reply-To: <20110623175725.GA21283@aepfle.de>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
	<1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
	<1308850515-15242-151-git-send-email-paul.gortmaker@windriver.com>
	<20110623175725.GA21283@aepfle.de>
Date: Thu, 23 Jun 2011 14:14:48 -0400
X-Google-Sender-Auth: a32cpeByPgPJBH2Ued5l3HQ-ipU
Message-ID: <BANLkTi=5nCHt370=6ZWg4ePLi1qh0w51cg@mail.gmail.com>
Subject: Re: [34-longterm 210/247] Input: xen-kbdfront - advertise either
 absolute or relative coordinates
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 1:57 PM, Olaf Hering <olaf@aepfle.de> wrote:
> On Thu, Jun 23, Paul Gortmaker wrote:
>
>> From: Olaf Hering <olaf@aepfle.de>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 8c3c283e6bf463ab498d6e7823aff6c4762314b6 upstream.
>
> This one will introduce a regression, which will be fixed by upstream
> commit c36b58e8a9112017c2bcc322cc98e71241814303
>
>    Input: xen-kbdfront - fix mouse getting stuck after save/restore
>
> Olaf

Thanks Olaf,  it will appear here shortly.

http://git.kernel.org/?p=linux/kernel/git/longterm/longterm-queue-2.6.34.git;a=summary

[PS: Dmitry - the mail.ru address you've been using in SOB lines always bounces]

Paul.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
