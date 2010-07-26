Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0GZUgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:36:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57277 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0GZUgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RttOtAnWg9j8r4Vii/X/Q7MLRyRH3ml1uuRUW7lLREgtOf9fuZ5sYxPJkBeCgYbDGs
         4cibG4gngkbwqQj/F56Tkuk1f/NyWRtITK1F1GD/HJQJxNr5IzGvpODoqiP4CdRTCH2a
         VvEkAiIlMs3J6v3/PLiRS9p8QcANS70iLeiyE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007231500180.2616@localhost.localdomain>
References: <201007202223.o6KMNDZl021345@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1007231500180.2616@localhost.localdomain>
Date: Mon, 26 Jul 2010 13:36:44 -0700
Message-ID: <AANLkTimo29pr8=st+5TWt5xNExrFmE7SCk-ZHqeTgq43@mail.gmail.com>
Subject: Re: [patch 1/3] hpet: factor timer allocate from open
From: Mag <maglyx@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, John Stultz <johnstul@us.ibm.com>,
        clemens@ladisch.de, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 6:07 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> And how exactly does this patch provide such functionality ? There is
> no interface which allows you to access the counter itself.

Yes there is, mmap allows you access the registers.
