Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1ARXuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:50:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35836 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1ARXuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:50:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=uDOD3E8bjCtqmzLXSk87Jeh/oNRGF2gLRZLeTbj1+rjatWAJA0ufqB+PsRiS8g8Ixi
         /8hAanN7nPUiwF6L/0XeLNE7gg+OEO7YQ7sTGMlvdZ/e1ree7hB1UdFnmjcYb0BvXsJm
         vUropg2e245h15FWAnpe/5qc22szyygwDcjXU=
MIME-Version: 1.0
From: Leo Prasath <leo.prasath@gmail.com>
Date: Tue, 18 Jan 2011 17:33:34 -0600
Message-ID: <AANLkTinjv_cLfZfNEf0LOxXAOEUNhsJ3uzPHiRVGGTWh@mail.gmail.com>
Subject: sleep in microsecond granularity in linux
To: linux-kernel@vger.kernel.org
Cc: Yiying Zhang <eggbaby150@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Is it possible to sleep in granularity of microseconds ?
>From what i know, there is msleep() which can sleep in milliseconds
and there is udelay() which busy waits for time in microsecond
granularity.
But I need to sleep ( not busy wait ) for granularity of microseconds ...

Is there a way to code a new API in linux kernel to allow this ? For
example using interrupts ..
Or is there a way to some external hardware timer cards that issue
interrupts after certain usecs ?

Any help / pointers/ tips will be very appreciated.

Thanks,
-Leo
