Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab1FXBWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:22:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1FXBWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n7131vv7ZMzXT6A2idH51jLMfxCnkKcnsRXdY/AciFqt6bG4b/ztVr3woh6ho5ijba
         im4TT4kESDVpIHrF6GlQ==
MIME-Version: 1.0
In-Reply-To: <20110624010835.GQ3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110623133950.GB28333@srcf.ucam.org>
	<4E0348E0.7050808@kpanic.de>
	<20110623141222.GA30003@srcf.ucam.org>
	<4E035DD1.1030603@kpanic.de>
	<20110623170014.GN3263@one.firstfloor.org>
	<987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
	<BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com>
	<20110624010835.GQ3263@one.firstfloor.org>
Date: Thu, 23 Jun 2011 18:22:17 -0700
Message-ID: <BANLkTinuuX+Ja64VJNfRbyf5NR+ga9PLnQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Craig Bergstrom <craigb@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "rick@vanrein.org" <rick@vanrein.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 6:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> We (Google) are working on a data-driven answer for this question.  I know
>> that there has been some analysis on this topic on the past, but I don't
>> want to speculate until we've had some time to put all the pieces together.
>>  Stay tuned for specifics.
>
> It would be also good if you posted your kernel patches.
>
> It's highly unusual -- to say the least -- to let someone's openly
> developed and posted patchkit compete with someone's else secret
> internal solution for review purposes.

Hi Andi,

This is quite hard to argue with.  Let me see what I can do.

Cheers,
CraigB

> -Andi
>
