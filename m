Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1EIQBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:01:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1EIQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gCORg82RmDNI935sRcQMk8gk+g3kZ653IcixpamwGvjxwEPfOnahXQ3i29xZJLHgtH
         PbbAez6XFQ7Uwd40Zn8WL2Mzx3aJO1Lf0tz+E1TnvPSj/C1UNZ6mrEjXsc4TqRJpqmS8
         QQvvsXM8yCk1udzihYOjQNcQQW5Izb+sC1Ga8=
Subject: Re: [PATCH] regulator: Support voltage offsets to compensate for
 drops in system
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1304889217-12319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1304889217-12319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:01:35 +0100
Message-ID: <1304956895.3192.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 22:13 +0100, Mark Brown wrote:
> Some systems, particularly physically large systems used for early
> prototyping, may experience substantial voltage drops between the regulator
> and the consumers as a result of long traces in the system. With these
> systems voltages may need to be set higher than requested in order to
> ensure reliable system operation.
> 
> Allow systems to work around such hardware issues by allowing constraints
> to supply an offset to be applied to any requested and reported voltages.
> This is not ideal, especially since the voltage drop may be load dependant,
> but is sufficient for most affected systems, it is not expected to be used
> in production hardware. The offset is applied after all constraint
> processing so constraints should be specified in terms of consumer values
> not physically configured values.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied.

Thanks

Liam

