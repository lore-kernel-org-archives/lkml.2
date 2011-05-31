Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1EaUsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:48:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61769 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab1EaUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K7Tz9Yicmvhe2oFFO4jfZH7qoOIGPgYR0UuY4Gn2OSgOMapBQqruOoA7xAARF+rNGA
         2nXkso9e1xFpTDrmJWUMUGMqMKbNnU+KliJqwXn1uKS8Z94ziiN/omC3ddhNizS/eB20
         pQFldjDjXzzf5byFVs+EvubOLXUi+e9kzCH8E=
MIME-Version: 1.0
In-Reply-To: <4DE4D0EE.20907@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
	<1304166750-31125-8-git-send-email-dsd@laptop.org>
	<20110516090813.GA26487@linutronix.de>
	<BANLkTimpFYMpQFY9J7pa0NygGoQ8dLdArA@mail.gmail.com>
	<4DE4D0EE.20907@linutronix.de>
Date: Tue, 31 May 2011 21:48:17 +0100
X-Google-Sender-Auth: YZR_DzBV-Y05gC7W1lvlCgqwZhM
Message-ID: <BANLkTiny5hKo3BRxCB-hNJTNYbvcfHkviw@mail.gmail.com>
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook switch functionality
From: Daniel Drake <dsd@laptop.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2011 12:28, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> Is this something like pin multiplexing? So it is either a GPIO pin with
> interrupt ability _or_ that PME thingy.

No, it's not multiplexing in that sense. It is either a GPIO that
generates an interrupt, or a GPIO that generates a PME.

We use it for both its PME functionality and its GPIO functionality.

Thanks,
Daniel
