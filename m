Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0DVVWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:22:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60299 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab0DVVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=QSsOuTi8+SaBWYfevbpEF1qhaEkj3vCrA8eeJuYcGS1tFScq2ViDM3rYFMCxdpZY/v
         E29BwyS1lDh6U1QyyFeDhpFX2U+cngRmNoIA2/4vp42nH8fEbkenNi56yebxn4DDsNiN
         zlbSsie6SRYMMW0kVOVoWnBRCjqZzcpuTL/bE=
MIME-Version: 1.0
In-Reply-To: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 22 Apr 2010 17:21:55 -0400
Message-ID: <p2v8bd0f97a1004221421x4bf0850fm1b47f4838c344368@mail.gmail.com>
Subject: Re: Should I really bother all maintainers with this?
To: Francis Galiegue <fgaliegue@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 17:12, Francis Galiegue wrote:
> This patch only fixes quite a common mistake in Documentation/, and if I
> scripts/get_maintainer.pl on the patch (which is recommended), I potentially
> mail thousands of people who probably have more useful/exciting stuff to do
> anyway. So, I submit it as is.

this kind of stuff usually goes through the trivial tree.  look at
TRIVIAL PATCHES in the MAINTAINERS file.
-mike
