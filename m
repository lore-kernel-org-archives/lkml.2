Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1BBU0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:26:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64785 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1BBU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Lr8HCOJw2lM69IZinUEKIN7qH5eBhF5XXLeUxmtwyiJzouFMiyhmU1sFkJbJxlBqGV
         A1u9twHSvLGM939+8n9OJ5NGRc+JNrYJtO+8CNtac/yHzdAE7IEFwhSVPcdmNDUEOK+8
         WZvjYs0Y0E7A4PshIG7SYcxC1Y+Ys3XF8fIME=
MIME-Version: 1.0
In-Reply-To: <20110202201913.GD28705@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
	<20110202144924.GD9810@sirena.org.uk>
	<AANLkTindwELkXft9phmiaduyB5icMCbAorbKxZMYP2bw@mail.gmail.com>
	<20110202201023.GC28705@opensource.wolfsonmicro.com>
	<AANLkTi=RZoqS1D3qQXJNupbBOcWLHdWiCNWmiVvvKV++@mail.gmail.com>
	<20110202201913.GD28705@opensource.wolfsonmicro.com>
Date: Wed, 2 Feb 2011 15:26:24 -0500
Message-ID: <AANLkTi=BjdYWL2+uCQZU0vucm1PC-PKN9i0AF5FUYcvy@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 2, 2011 at 3:19 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 02, 2011 at 03:16:41PM -0500, Arnaud Lacombe wrote:
>> On Wed, Feb 2, 2011 at 3:10 PM, Mark Brown
>
>> > Oh no, not another one :(
>
>> Care to explain ?
>
> It's a config option which is pretty much always has one setting and
> causes build hassle if the other setting is chosen.
>
I know. I never said "turn it off", I just said what is coded in
`include/asm-generic/bug.h'. Beside that, it is exposed in Kconfig,
and no matter what, people will try to turn it off, may it blows their
kernel and/or hardware.

A.
