Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0ERAaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:30:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37744 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0ERAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Rc8mGBYnqUnlDJv311ifli8N97mmWZayvWRiz9qfmNKM4dc9xRBHsmfZlNlfWRUCY1
         +HdkOf9dgRocC4P3dj7RHDEmy6WIlkrUXyuIrcEnbeP7zcG91wejbozfEC8+c71RjjBN
         W+1hfZYjLXdRq+H6Ht8mTEg1Y5QY1UdKptiBw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinUgXVhhdWqb0tOCgQC6ai2LoDSkezehIIvX8W9@mail.gmail.com>
References: <1274136092-12375-1-git-send-email-linus.walleij@stericsson.com>
	 <AANLkTinUgXVhhdWqb0tOCgQC6ai2LoDSkezehIIvX8W9@mail.gmail.com>
Date: Tue, 18 May 2010 02:23:08 +0200
Message-ID: <AANLkTimqf9nFlrhLCv2O6Nnxhrxf8jHsFyMvc4q6HSUf@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMAENGINE: extend the control command to include an 
	arg
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/18 Dan Williams <dan.j.williams@intel.com>:

> This one required some fixups, but I have made those and pushed the
> result out async_tx.git/next along with the other two.

Thanks, and sorry for the mess, I haven't replicated your regression
compilation test, sadly.

Yours,
Linus Walleij
