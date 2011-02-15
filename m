Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1BOTgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:36:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45517 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab1BOTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:35:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K+FC5asFzK3UrptwJUrqhCyl+2JhSQsWIw/O3Y8FmBvIKj2i7hGzWrYmjVHt7P2TyY
         YFE182pG5o1ZVCLXtboUPzMgZ8bTXWv+I0ts9ixcVkvbxKl3pjEhFVaJxA7QGDRVE6lz
         GJFsNnAiNeAGGrk02CW2q4i2yBQ0q5HQvc1sY=
MIME-Version: 1.0
In-Reply-To: <20110214115523.25875.45143.stgit@localhost6.localdomain6>
References: <20110214115523.25875.45143.stgit@localhost6.localdomain6>
Date: Tue, 15 Feb 2011 20:35:55 +0100
X-Google-Sender-Auth: UJEqMfCekNhTRVPns3I1v2pFls8
Message-ID: <AANLkTimetQAorEei_ktU+w_=8S6qG3Xy8x=rQb5n9YME@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add slave-dma maintainer
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/14 Dan Williams <dan.j.williams@intel.com>:

> I have asked my colleague, Vinod Koul, to:
> 1/ put more definition around the slave api and usages to try to ensure
> consistent behavior across drivers (as much as possible)
> 2/ help review and merge new drivers according to this definition

Excellent choice, thanks to Dan & Vinod for taking on this!

Yours,
Linus Walleij
