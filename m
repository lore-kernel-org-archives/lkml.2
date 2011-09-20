Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1ITR7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:59:09 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:55135 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1ITR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110920175551.GA4187@core.coreip.homeip.net>
References: <20110920175551.GA4187@core.coreip.homeip.net>
Date: Tue, 20 Sep 2011 13:59:05 -0400
Message-ID: <CA+5PVA7WA6QorzgiOHEDw9HCoLO0UbGYMS34r3Ds01w854YoHA@mail.gmail.com>
Subject: Re: EXT4: lockdep complaints on 3.1-rc4+
From: Josh Boyer <jwboyer@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 1:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi,
>
> Not sure if it has been reported but I just got the following lockdep
> warning on 3.1-rc4+ + my input queue (which does not touch FS code at
> all):

IIRC, that should be fixed with
8c0bec2151a47906bf779c6715a10ce04453ab77, which is in -rc5

josh
