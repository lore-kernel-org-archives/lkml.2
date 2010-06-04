Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab0FDEbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:31:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55905 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0FDEbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GjYenLuU67GVtzgI3SZ9TclglAiXDcAnuk+RBHsF25NGXhM4F4hCQ0K9a5+QGBghvp
         oFnGLoMLAaX8ibkMIIDqpaYupc/0GixBemsL30afn8m/81RHjAHLRyvXS+DsgFX91VLu
         dAP/XfuTPamlpLJw1qzgNmaKZnghUOe8vSkxA=
MIME-Version: 1.0
In-Reply-To: <AANLkTikBtcHTAE-4JrpOM4GGa45MCcVRKs6vK0YMBATc@mail.gmail.com>
References: <1275623379.1515.1.camel@eight.analog.com>
	<AANLkTikBtcHTAE-4JrpOM4GGa45MCcVRKs6vK0YMBATc@mail.gmail.com>
Date: Fri, 4 Jun 2010 12:31:03 +0800
Message-ID: <AANLkTikOo3qjHVmmOT7IsFGRas6-EqsDWzKoUGyqPCBD@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v5] regulator: new drivers for AD5398 
	and AD5821
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 11:46 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Thu, Jun 3, 2010 at 23:49, sonic zhang wrote:
>> +static const struct regulator_ops ad5398_ops = {
>> +static const struct regulator_desc ad5398_reg = {
>
> when i said these should be const, this isnt something that can start
> with the drivers.  the core needs to be fixed first.  otherwise these
> simply trigger warnings.
> -mike
>

This is a typo error.

Sonic
