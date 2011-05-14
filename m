Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab1ENUWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:22:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61790 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ENUV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MG1fmzmT1AiOQLOelFeDSB+4NwucTngnczXWmoZVxDHamCcpDNyGVAGSVtxlCsaSNE
         LtdB4uO1i8voQI9C8Yh0tuzp3fS5a813WvKfKIqVWwvMVGPWEfmX9Bp1LR0OQfEX7fPp
         aClhtOc0IIh0bZt0qXriAOXr1ZzqZvu0EG/pY=
MIME-Version: 1.0
In-Reply-To: <201105131854.57854.rjw@sisk.pl>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
	<201105122127.44484.rjw@sisk.pl>
	<BANLkTikZkRW6TWMcWyZC4_TdAWgjXDqvYA@mail.gmail.com>
	<201105131854.57854.rjw@sisk.pl>
Date: Sat, 14 May 2011 22:21:57 +0200
Message-ID: <BANLkTi=0T_jmEju+cP8zG8EC0ns-mwKHYw@mail.gmail.com>
Subject: Re: pm loss development
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I read the patches.  My question was about the general idea of who should
> be responsible of making these decisions.

The best  should be, I think, to have some guidelines and than the
possibility to choose the best policy for each situation.
In my board I needed to shutdown video in capture and demodulator
circuit, so I have implemented vpfe capture switch off, that does
stream_off to all its v4l2 subdevices (a pal decoder and a video
demodulator).
So I can save 30mA, and it allows to my board to survive longer.
I need to do some tests and have some data with and without PM loss.

Bye,
raffaele
-- 
www.opensurf.it
