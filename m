Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1FPGgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:36:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1FPGgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:36:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110615144823.GA2806@opensource.wolfsonmicro.com>
References: <20110615144823.GA2806@opensource.wolfsonmicro.com> <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com> <5194.1308074912@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, grant@secretlab.ca
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Date: Thu, 16 Jun 2011 07:36:31 +0100
Message-ID: <19624.1308206191@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Could you be more specific about the issue you see here?

I was specific:

	Take gpio_get_value() for instance, it requires __gpio_get_value() -
	which is defined by the asm-generic header - but is used by
	gpio_get_value_cansleep() in the asm-generic header.

gpio_get_value() is defined in the arch header.

David
