Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1G2NI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:08:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35205 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab1G2NI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:08:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110729123420.GB22042@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
	<1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
	<1311762767-20263-4-git-send-email-marcus.folkesson@gmail.com>
	<20110729123420.GB22042@sirena.org.uk>
Date: Fri, 29 Jul 2011 15:08:54 +0200
Message-ID: <CAM8FrKL4-hn2rrazsCLrRoVY5zVkgR8A245ScfS48=O41jtffg@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: tps65023: Added support for the similiar
 TPS65020 chip
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Jul 27, 2011 at 12:32:47PM +0200, Marcus Folkesson wrote:
>
>> +static struct tps_driver_data tps65020_drv_data = {
>> +             .info = (struct tps_info *) tps65020_regs,
>
> Why do you need the cast here?  I see it's in the original driver too
> but it looks like something that should be fixed.
>

I also thought about the line, It's only for avoiding warnings from gcc.
But I don't really understand why gcc is warning.

gcc output:  "warning: initialization discards qualifiers from pointer
target type".
