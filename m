Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1AJNyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:54:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1AJNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s13Tc2I58ZDHsMRMC9BmhtxfARIQy+IX60bKTBeEYm2lFjg78nDVMmLByHmPlvjtGI
         hxe8R8H9YpLjT3+6a94zgquwEHFKS78NU7EYUqDbmm4RBuBUSkDrkfNJ8ueEonDkhOpd
         Qd729XrV0a+pxuHMWR+muQMxMG/vus7YOfTxg=
MIME-Version: 1.0
In-Reply-To: <f853a77e2aebea4130fc486bdbf4aa06@mail.gmail.com>
References: <20101223171859.f6842045.sfr@canb.auug.org.au>
	<4D139517.3010608@ti.com>
	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>
	<AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com>
	<AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com>
	<4D271E0E.8050401@ti.com>
	<AANLkTikLQRHyp-TS_idEp5Fr74qC3vDoMqqsAA2v_oV8@mail.gmail.com>
	<c822ad4569a9dc865b5ccf39e12c828b@mail.gmail.com>
	<f853a77e2aebea4130fc486bdbf4aa06@mail.gmail.com>
Date: Mon, 10 Jan 2011 21:53:54 +0800
Message-ID: <AANLkTimakCyo5WB4v677-y+V=EO3nPiMTh+msnxkJiwH@mail.gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
From: Ming Lei <tom.leiming@gmail.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/1/7 Anand Gadiyar <gadiyar@ti.com>:

> Update: I disabled CONFIG_OMAP_RESET_CLOCKS and the PHY and other
> connected devices enumerate just fine. Could you try this out on
> your board as well?

Yes, it does work for me if CONFIG_OMAP_RESET_CLOCKS is disabled.

thanks,
-- 
Lei Ming
