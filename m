Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1CJRNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:13:16 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49031 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1CJRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B5FWVKqGms51gQXNfS2NzmDqno9GVNM/w9VyYuHc5Voqd/tCnCDi1QR94helB1FWPB
         nAWnsPlVjsURLOkyMYHzyrvAeVgSPgr8zcOHuPJQK/2uDDTZVOtrsoBesJbuj4mnFpO1
         0ZN91j6df8SpPX6dFLlEKoSULEmtYgv7iF1LY=
MIME-Version: 1.0
In-Reply-To: <20110310170143.GA24559@kroah.com>
References: <20110209224006.GA11202@kroah.com>
	<AANLkTikrr6Gu_qoq73ASC95E0HQC1p6KzDPLxo=J_rva@mail.gmail.com>
	<20110225210334.GB16860@kroah.com>
	<4D6823DD.6040809@gmail.com>
	<20110225225055.GA5931@kroah.com>
	<4D787714.6060405@gmail.com>
	<20110310170143.GA24559@kroah.com>
Date: Thu, 10 Mar 2011 19:13:14 +0200
Message-ID: <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
From: Nikolai Kondrashov <spbnick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Mar 10, 2011 at 7:01 PM, Greg KH <greg@kroah.com> wrote:
> Ok, then I'm afraid that this driver will not support your laptop,
> sorry.
Oh, heck! I forgot I've upgraded my netbook to n230 (which is not
supported as I see now) and left n210 to my wife.
I'll test it on n210 and then report back to you.

Sorry for the noise.

BTW, I'm ready to test n230 support, if you implement it.

Sincerely,
Nick
