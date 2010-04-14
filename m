Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0DNPBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:01:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7836 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab0DNPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oWcMF/m4IqikvlPRTOCXRPTUrWPol+6hUc7ux+HlcWjXRW2DFQOTJIEQKAl8dCdIBR
         F7/q9rp5e6FLb1XnxR7ltnjqJo3FfiTUdkgSEkYqQX+1aw7kXAW7ILJZZnz0/GEJiwmy
         4b1RlyDvdsL6bTq4HAy7dURw+2DHM3/dXPMlc=
MIME-Version: 1.0
In-Reply-To: <4BC57977.7000705@atmel.com>
References: <1270115336-19488-1-git-send-email-nicolas.ferre@atmel.com>
	 <l2ocd73a99e1004130042qfe9aba83l512a0fad50112d19@mail.gmail.com>
	 <4BC57977.7000705@atmel.com>
Date: Wed, 14 Apr 2010 17:01:12 +0200
Message-ID: <t2rcd73a99e1004140801ybff81f03x5c7fae2ace55afd6@mail.gmail.com>
Subject: Re: [PATCH] AT91: at91sam9g10 chip identification changed
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> I do not think it is a good idea:

Ok.  Then we'll go with your original patch.

 Acked-by: Andrew Victor <linux@maxim.org.za>
