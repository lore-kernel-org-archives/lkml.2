Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0LANY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:24:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52443 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0LANY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nWd7mXvUJz9UWez7e5f6i+4KkTYF7IeIRNgLOfELbvihdJiCAZPp5u1pf79Y8sAVtl
         ptZ8BZyr6vYApc5z28V4ldc/OINVz/Qyp0KAAqcmVXqxT192/cdlw5xIYBkpdVyucKJf
         oXKw02F1Jb5IIuDTD4EgNBeERzk9Wsm1sbeUg=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201123921.GA15530@a1.tnic>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	 <20101201123921.GA15530@a1.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 14:24:48 +0100
Message-ID: <1291209888.12511.11.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 01.12.2010, 13:39 +0100 schrieb Borislav Petkov:
> On Wed, Dec 01, 2010 at 12:01:47PM +0100, Tobias Karnat wrote:
> > Hi,
> > 
> > I have a problem with the edac_core module in 2.6.36.1, it crashes on shutdown.
> > If I remove it manually, it does not crash.
> > 
> > I compiled the edac modules from 2.6.35 against the headers of 2.6.36.1 and they are fine.
> 
> What does that mean? Are you using an official kernel version or
> something you cooked up?

I'm using the official 2.6.36.1 kernel.
The problem happens with the modules from the kernel 2.6.36.1

But as a workaround for now,
I'm using the edac modules from 2.6.35 compiled for 2.6.36.1
I'm just saying that the problem only occurs on kernel >= 2.6.36


> Please try to catch the whole oops. I can see rIP but it'd be much more
> helpful to see the calltrace and the whole register dump which are cut
> off at the bottom of your pic.

Yes, here you go:

http://i55.tinypic.com/igyhpt.jpg

-Tobias



