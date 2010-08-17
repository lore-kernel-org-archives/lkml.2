Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0HQSQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:16:38 -0400
Received: from mail-pw0-f66.google.com ([209.85.160.66]:42910 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab0HQSQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Z9Mb4klopCQi0hpAPBJMYyxjDkKjZxVAgx4YVF9utKZtPjVjCfyX3mmfoAoFIPMwRb
         40BWBFuZqahag2JlS9ly6Ttdmyk8wJgzNma5vSMELcGVIlNDHSq8AM1m6BcOt6kF5Ixa
         S969GJ5J9Hz4YCvsSCGXdxT7O7F8/i9ad5wwc=
MIME-Version: 1.0
In-Reply-To: <20100817162052.GA12785@a1.tnic>
References: <20100817021252.GA17647@foursquare.net>
	<20100817053456.GA32714@liondog.tnic>
	<20100817062801.GA24978@foursquare.net>
	<20100817063159.GC32714@liondog.tnic>
	<20100817155333.GA17624@foursquare.net>
	<20100817162052.GA12785@a1.tnic>
Date: Tue, 17 Aug 2010 20:15:21 +0300
Message-ID: <AANLkTi=WWmOc4UVUxp_5w43zbZhP5nBfcv6oMCYNyuKE@mail.gmail.com>
Subject: Re: compiler warnings in 2.6.35.2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Chris Frey <cdfrey@foursquare.net>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 7:20 PM, Borislav Petkov <bp@alien8.de> wrote:
> So why do you want to stay with 3.x anyway?

Read this: http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/BUILD.LOG
Search for warnings.
I tried to complile myself (using ubuntu 10.10 with latest updates),
but failed at some staging driver. After uncheked the staging drivers,
still failure.
I'm using kernel 2.6.36-rc1 from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/
