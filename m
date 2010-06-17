Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab0FQQqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:46:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58727 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0FQQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cS860Nc7zUeFJPtp7Q6Z0cND7BSEnSEXVe7vbsn77DGZJroqXjA6advduPeASHb5Z7
         cITThebwtzIRt6Q1Z/2VIM4FRiM3r7NVZEfgSgR0hfj0YICNa5Eynd+eff/kV7hQ5asI
         uy0gXMJHwOM+DCU5+spnDj8JMvIAZ1jvEuFh8=
MIME-Version: 1.0
In-Reply-To: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
References: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 17 Jun 2010 18:46:42 +0200
X-Google-Sender-Auth: nsep664BEgden3RoY4DQCK6XlTk
Message-ID: <AANLkTim_j9atBiKb5L536l33UDE_nYVgIbu4gaJcUMu3@mail.gmail.com>
Subject: Re: [PATCH] MFD: AB8500 mask off irrelevant bits from the SPI message
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/28 Linus Walleij <linus.walleij@stericsson.com>:

> The registers on the AB8500 are only 8 bits wide, so the content
> of the remaining bits is undefined. Let's mask off the undefined
> stuff when returning a register in an SPI read.

Are you picking this one up Samuel?

Yours,
Linus Walleij
