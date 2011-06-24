Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab1FXBJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:09:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46005 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905Ab1FXBJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SJfj8RiCg+4i9iVk13pe1ay33LSShgsjRm/lF70GjLJRotSG+5eBxmP3NbufiOhmL2
         r6WEmJF6ohjI5s0BsC5g==
MIME-Version: 1.0
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110623133950.GB28333@srcf.ucam.org>
	<4E0348E0.7050808@kpanic.de>
	<20110623141222.GA30003@srcf.ucam.org>
	<4E035DD1.1030603@kpanic.de>
	<20110623170014.GN3263@one.firstfloor.org>
	<987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
Date: Thu, 23 Jun 2011 18:09:14 -0700
Message-ID: <BANLkTi=39V3MeQi9T9X8g1O7g0w6FNLGyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Craig Bergstrom <craigb@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:12 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> I don't think it makes sense to handle something like that with a list.
>> The compact representation currently in badram is great for that.
>
> I'd tend to agree here.  Rick has made a convincing argument that there
> are significant numbers of real world cases where a defective row/column
> in a DIMM results in a predictable pattern of errors.  The ball is now
> in Google's court to take a look at their systems that have high numbers
> of errors to see if they can actually be described by a small number
> of BadRAM patterns as Rick has claimed.
>

Hi All,

We (Google) are working on a data-driven answer for this question.  I
know that there has been some analysis on this topic on the past, but
I don't want to speculate until we've had some time to put all the
pieces together.  Stay tuned for specifics.

Cheers,
CraigB


> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
