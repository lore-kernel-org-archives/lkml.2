Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1JXWkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:40:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53574 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1JXWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20111024223223.GA4351@opensource.wolfsonmicro.com>
References: <1319493561-4094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111024221004.GE4394@ponder.secretlab.ca> <20111024223223.GA4351@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Oct 2011 00:40:11 +0200
X-Google-Sender-Auth: Fgl3c1wACWWVtCxVXHkOH8GN4a8
Message-ID: <CACxGe6vvbbBk0HYPe646K075QoS0k3nOqJCyPSwMw9Nd=8k05A@mail.gmail.com>
Subject: Re: [PATCH] h8300: Move gpio.h to gpio-internal.h
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:32 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Oct 25, 2011 at 12:10:04AM +0200, Grant Likely wrote:
>
>> This of course should go via the h8300 tree instead of the gpio tree.
>
> If you look at the commit history there's not been much h8300 specific
> work going on for quite some time now - all the commits have been going
> via other trees - so since it's basically a gpiolib cleanup I figure
> it'd be less work for Sato-san if you were able to pick it up.

Okay, will do.

g.
