Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0HJJOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:14:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S1c/NveSx7FikbFelnUEilB+2iwNunebbyNiU2VBV9hPzRYhLr4H5rRbeLD8wmF545
         EgWo1Y6yT6TPqp5X6htKIorg5jnQIY1KMoLhQxs2MXSfS99Cg8qO1g7qaoX4Hm+dpdZk
         kMIBw1EdtfSF0+aavrQuTp+ZioUjEst1A9UBY=
MIME-Version: 1.0
In-Reply-To: <1281010151.2063.8.camel@alex-desktop>
References: <1281010151.2063.8.camel@alex-desktop>
Date: Tue, 10 Aug 2010 12:14:10 +0300
Message-ID: <AANLkTi=YessPd6cHhLdveyrSq_TcY1Vx1LxpCNLthEJG@mail.gmail.com>
Subject: Re: [PATCHv2] fixed resource leak in scripts/mod/modpost.c
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 3:09 PM, Alexey Fomenko
<ext-alexey.fomenko@nokia.com> wrote:
> Patch modified for released 2.6.35 kernel.
> sec2annotation returns malloc'ed buffer directly to printf as an
> argument. Patch lets free this buffer after printing.

Needs to be amended.
I told Alexey in private to resend new version of the patch.

-- 
With Best Regards,
Andy Shevchenko
