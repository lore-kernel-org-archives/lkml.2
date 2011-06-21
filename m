Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1FUHRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:17:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61579 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1FUHRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WAETnAWPkFYwpuv4RKWuC1Ko1zz3o3HIUvB+GEHqk/7rNFv5MPl5RtkXn9oxUP6REq
         nzvmzSeB1Yl90GodLrJSpYWHS51dPEdT4Mr0U5vbblpxi274/enshgXL/6J1QcMo4C5y
         JBlE5UiYk5G0e+TUanmu2x+vNhYxIDlRnY9Jw=
MIME-Version: 1.0
In-Reply-To: <BANLkTinYh7doQt_6E7zOy6obhogFxB+hMA@mail.gmail.com>
References: <20110617120704.GH2611@htj.dyndns.org>
	<1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
	<20110620081937.GN2611@htj.dyndns.org>
	<BANLkTinYh7doQt_6E7zOy6obhogFxB+hMA@mail.gmail.com>
Date: Tue, 21 Jun 2011 09:17:24 +0200
X-Google-Sender-Auth: 6TKwI6W5gWbpW1C9-Hl1jpo9f1I
Message-ID: <BANLkTik-L1MNQspeaMhfxe4Uy1YGV+t6FA@mail.gmail.com>
Subject: Re: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and
 rename it
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@mvista.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 21, 2011 at 5:24 AM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
>> It would be better if the name reflects that it's not for specific
>> workaround.
>
> Do you mean it would be better to name it for specific workaround?

Yes, I meant that. An extra 'not' there.

> How about ahci_bad_pmp_check_ready? Because this function is
> to avoid checking TFDATA if BAD PMP is found.

It's minor anyway and I don't think it matters all that much as long
as we make the actual reset and ops names not too confusing.

Thank you.

-- 
tejun
