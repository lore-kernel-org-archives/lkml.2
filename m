Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab1GRGl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 02:41:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60368 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRGlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 02:41:55 -0400
Subject: Re: Spinlock assembly clarification
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frank Coldwell <spaceportz@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CABAWUvV2er1niFGcXacMXdzMh46iAA_cHrO1mNaWXMcYc+GW3Q@mail.gmail.com>
References: <CABAWUvV2er1niFGcXacMXdzMh46iAA_cHrO1mNaWXMcYc+GW3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 08:41:50 +0200
Message-ID: <1310971310.2509.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 18 juillet 2011 à 09:30 +0400, Frank Coldwell a écrit :

> So to understand this I look at intel manual for these instructions,
> and I could not find anything
> for instruction xaddw ??
> 

Look for XADD

The W suffix means we operate on a 16bit word.

http://faydoc.tripod.com/cpu/xadd.htm


