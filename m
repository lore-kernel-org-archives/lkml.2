Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0IUSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:23:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62026 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0IUSXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hkdsnF7rhCImJB3sAJ1glCxN/7AtRrG1xk9tShk7cJAWTqzUNbRK2LdkYiINZn4fq5
         6UsItEs1CHM21UePOki/i3qblT86yO9EkVCW6zyXVvEM8GMGmjB4jduumgwM9pQPlf5P
         juikIWcoeKfvg0zKt0zZ7uyvXNF+ZK3jpXgJY=
MIME-Version: 1.0
In-Reply-To: <20100921181250.GA11157@suse.de>
References: <19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
	<20100831224238.GA13253@suse.de>
	<19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
	<AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
	<AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
	<AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
	<20100921173719.GA11404@suse.de>
	<AANLkTim1cjcXf+eB7O9cTfEu1s=+-eL3uZ=UcXvb8H4M@mail.gmail.com>
	<20100921181250.GA11157@suse.de>
Date: Tue, 21 Sep 2010 21:23:43 +0300
Message-ID: <AANLkTin=GRFiJbX2t5gRVkhitsKNAaFmtEvqmmG51fB7@mail.gmail.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: "Savoy, Pavan" <pavan_savoy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a specific patch that fixes this issue that is not around?  Or
> is it already in my staging-next tree and you feel it should be added to
> the final .36 release?
>
> If so, which one is it?
>
> thanks,
>
> greg k-h
>

for the build problem, include it in 2.6.36
no need for more delay.
