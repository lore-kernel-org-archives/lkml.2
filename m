Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1EaSua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:50:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1EaSu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=v9bYfS6OcwTGJO0EkphgAB97t4ns+tpCiCBW//B740e9nxrIVhDe8rFBV8wkcRgjFE
         qhqx/rNT4cRWAqFIqxrg==
MIME-Version: 1.0
In-Reply-To: <20110531124208.GF11352@atomide.com>
References: <1304546278-28965-1-git-send-email-ccross@android.com>
	<20110531124208.GF11352@atomide.com>
Date: Tue, 31 May 2011 11:50:23 -0700
X-Google-Sender-Auth: DHfZHm246YNZmnYqw7Z7TysArUI
Message-ID: <BANLkTikfXs1oLott64+C5wy59G24Mux0TJ52et7GTEMQrfqRFQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: omap4: Pass core and wakeup mux tables to omap4_mux_init
From: Colin Cross <ccross@android.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        l-o <linux-omap@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 5:42 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Colin Cross <ccross@android.com> [110504 14:54]:
>> OMAP4 contains two separate instances of the padconf registers,
>> one in the core system config and one in the wakeup system config.
>> Pass in two tables to apply the correct values to each instance.
>
> Hmm good catch thanks. Will queue this as a fix.

This patch doesn't work without another fix to allow NULL to be passed
to omap4_mux_init.  Do you prefer allowing NULL, or adding empty
board_wkup_mux arrays to every board file?  I have a patch for the
first option.
