Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2KGX1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:27:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35614 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2KGX1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net>
References: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com>
	<1352313131.2751.152.camel@fourier>
	<C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net>
Date: Thu, 8 Nov 2012 00:27:37 +0100
Message-ID: <CAFLxGvy3voev7gm=6sej=tNmWOB31Kgf6gFZf5ew7xh9r1qRGA@mail.gmail.com>
Subject: Re: Why Cypress does not upstream its trackpad driver?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Troy Abercrombia <ta@cypress.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        customercare <customercare@cypress.com>,
        "mario_limonciello@dell.com" <mario_limonciello@dell.com>,
        David Solda <dso@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 12:13 AM, Troy Abercrombia <ta@cypress.com> wrote:
> Hello Kamal
>
> Unfortunately, We're not able to upstream the driver as it would be denied because it changes the Linux mouse structure framework.

Then write a sane driver or submit patches which add the features you
need in the Linux input device framework...

-- 
Thanks,
//richard
