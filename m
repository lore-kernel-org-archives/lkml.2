Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1BBUG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:06:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61240 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1BBUGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:06:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wr3h8Y79QJF5quwlM3CfL0oLo8vfKfptB7FtA7F7aKgCqbixOIrQ5uOAybu/Narfav
         JRR9gnaxc6XIANCn/njHHX9Tjtbw1SX3We9d6zX0uw1kpoKEZTQ0UKVgLrkazQ83BPdB
         eMw1JCgRQrr6zZmig9oB873YtpqHZVLYq/P88=
MIME-Version: 1.0
In-Reply-To: <20110202144924.GD9810@sirena.org.uk>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
	<20110202144924.GD9810@sirena.org.uk>
Date: Wed, 2 Feb 2011 15:06:53 -0500
Message-ID: <AANLkTindwELkXft9phmiaduyB5icMCbAorbKxZMYP2bw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 2, 2011 at 9:49 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 02, 2011 at 03:05:16PM +0100, Geert Uytterhoeven wrote:
>
>>       src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 =>
>
> Either your compiler or architecture isn't noticing that BUG() can't
> return.
>
if CONFIG_BUG has been set to "n", it _will_ return. It could have
been made to trigger a crash, but it did not, on purpose.

 - Arnaud
