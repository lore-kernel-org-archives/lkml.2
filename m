Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0HMHIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:08:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45025 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994Ab0HMHIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:08:02 -0400
X-Sasl-enc: roSKg/hXO6I0swwtB59M+HUSFLkQXXhExDA9NljUpVAd 1281683280
Message-ID: <4C64EF69.7040804@ladisch.de>
Date: Fri, 13 Aug 2010 09:08:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [REGRESSION 2.6.35+] Pulseaudio fails to work with
 sound device
References: <1281644945.3893.18.camel@maxim-laptop>
In-Reply-To: <1281644945.3893.18.camel@maxim-laptop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Trying to migrate to git master of kernel tree I see that my sound
> stopped working.

Probably this bug:
http://mailman.alsa-project.org/pipermail/alsa-devel/2010-August/030526.html


Regards,
Clemens
