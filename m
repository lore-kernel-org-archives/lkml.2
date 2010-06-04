Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0FDDqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:46:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43597 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab0FDDqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GSyEq/RjAcLSgTq2915nSwJLa1LjBS38X0EvrwvTr9yYAuV4s1Rqsf7Tlq9oBBQGms
         7q6zJLMc6Hjvb4BiAut/ELZZv58e+5FSR0F/3D4cM497ruMpF5U/E2OOBM9pT1mUSpqe
         FkEkkhVBjO0VmqM+PrcDErvTmWgTwgaed1b20=
MIME-Version: 1.0
In-Reply-To: <1275623379.1515.1.camel@eight.analog.com>
References: <1275623379.1515.1.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 3 Jun 2010 23:46:10 -0400
Message-ID: <AANLkTikBtcHTAE-4JrpOM4GGa45MCcVRKs6vK0YMBATc@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v5] regulator: new drivers for AD5398 
	and AD5821
To: sonic zhang <sonic.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 23:49, sonic zhang wrote:
> +static const struct regulator_ops ad5398_ops = {
> +static const struct regulator_desc ad5398_reg = {

when i said these should be const, this isnt something that can start
with the drivers.  the core needs to be fixed first.  otherwise these
simply trigger warnings.
-mike
