Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1DFUmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:42:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1DFUms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PLVUDModclMuBrDspjnMJL9yHh7g9kEMcE47z4sS7Fkd3HDGWxvfzWfLufn6ZhON5U
         KjK+G8XX7KSYD9p7v+0Il5VIutzkJTslNKlrTJbL8sFfnGIC2q8OvGbgez30mjgNxydn
         nvA4tAB2YQCvI/ou1ScuIFks3Uw8GXVraS/30=
MIME-Version: 1.0
In-Reply-To: <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	<op.vti9ote53ri7v4@arend-laptop>
	<BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
Date: Wed, 6 Apr 2011 22:42:47 +0200
Message-ID: <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/6 Rafał Miłecki <zajec5@gmail.com>:
> If we want to have two drivers working on two (different) cores
> simultaneously, we will have to add trivial mutex to group core
> switching with core operation (read/write).

With a little of work we could avoid switching and mutexes on no-host
boards. MMIO is not limited to one core at once in such a case.

-- 
Rafał
