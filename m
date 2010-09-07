Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab0IGRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:35:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51021 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab0IGRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CGL3MtVWjv5qfoBfd4SUaOd8d9+KHp4QYhRL64Nk6+jY+6eIJT/j7KF/6mUnPqM/xN
         TBeieuJkLeH4nyHVtfcj6+ItKZfCQDmI/gbLKIqDYIJjzx8ySpe222jUA94OCrfn8G/x
         izX5iFv4ECVp43GXnpr76StfQgOhP6yfGw+xI=
MIME-Version: 1.0
In-Reply-To: <201009071517.43009.ptesarik@suse.cz>
References: <201008271537.35709.ptesarik@suse.cz>
	<AANLkTikZRiQ5jCpgp42LxtXb_S52sSUy7KP_=vZ3z4Tf@mail.gmail.com>
	<201009061647.02345.ptesarik@suse.cz>
	<201009071517.43009.ptesarik@suse.cz>
Date: Tue, 7 Sep 2010 10:35:47 -0700
Message-ID: <AANLkTikdHZY1sOJFCMn8Zaca2rO6MsbXL459LZ4HOJTk@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 6:17 AM, Petr Tesarik <ptesarik@suse.cz> wrote:
> Anyway, after applying the following patch, the test case provided by Hedi has
> been running for a few hours already. Now, I'm confident this is a hardware
> bug.

Started up a test with this patch on my 32-way to confirm.

-Tony
