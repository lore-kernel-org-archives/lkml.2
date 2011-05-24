Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1EXOJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:09:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45440 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1EXOJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vcnu2NXSsbfD5bLO/tlSFAiKvfEMhKQ6Z/2ZFNXxh4vmGO4+gUdwkgfa15io5uG8US
         awJPx7GltdEbc3I88xFC/M3FWhFw20H7yTlz63hr6NCcigFdAUBcFFFOuGzN/ly5gS0Z
         cUoMwMg2qpfFWR5vHfid/S0xVNKhA3FsqPH6M=
MIME-Version: 1.0
In-Reply-To: <web-530857881@zbackend1.aha.ru>
References: <web-530857881@zbackend1.aha.ru>
Date: Tue, 24 May 2011 10:09:46 -0400
Message-ID: <BANLkTinachR0M-cHzj3d4XmTOMWfCBASdA@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: Jerome Glisse <j.glisse@gmail.com>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 9:40 AM, werner <w.landgraf@ru.ru> wrote:
> Version numbers should not be only numerology, but connected to quality or
> progress.  Comparing the situation of the 1, 2.0, 2.2, 2.4, 2.6 versions,
> since starting 2.6 , the progress of the kernel, and also the situation of
> Linux as a whole and of its use changed very.  Exactly in the last
> subversions with many new hardware modules/drivers the quality improved
> very.  At the same time, the subversions becomes too much since the last new
> version.  Thus, it's time for 2.8 or even 3.0 in order to mark this very
> improved quality and use of Linux since the start of the 2 and 2.6 versions.
>    wl
> ---

If i were to give my feeling, and i am doing it right now, i wish that
such version change to be backed with things like removal of dead code
for instance in the GPU side we would like at one point to drop non
KMS path and delete a whole bunch of files and dead API in the process
(at least that's on my bad santa list). Non KMS is in survival mode,
at this point we try to not break it but we don't give shit about it.
Bug against it are redirected to the closest black hole.

Cheers,
Jerome
