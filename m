Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab0EZLSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:18:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49248 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0EZLSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=t977FUkoaZ7GJ6lc2JYS4icBCKkVerx1ARd4Cql0zopHblF5FmhiBSiySDEoNldTbl
         OKz+e9oajpaMvdFRWgT1dvOjsG+Eopy7o3k1k07pKX8UXkTavDl4XZpxd1T3sy0Wywta
         e0dusp1pqsGl1fI7VSlqRRI2nfalnR3woTFUI=
MIME-Version: 1.0
In-Reply-To: <20100526120242.5c9b73ad@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
Date: Wed, 26 May 2010 13:18:51 +0200
Message-ID: <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Vitaly Wool <vitalywool@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:02 PM, Florian Mickler <florian@mickler.org> wrote:

>> So why again was this such a great scheme? Go fix your userspace to not
>> not run when not needed.
>
> Hi Peter!
>
> This was already mentioned in one of these threads.
>
> The summary is: The device this kernel is running on dosn't want to
> (or can) rely on userspace to save power. This is because it is an open
> system, without an app-store or the like. Everyone can run what he
> wants.

I don't see this as a valid point. Everyone can run a different kernel
where nothing will just work. Are you aiming protection against that
as well?

~Vitaly
