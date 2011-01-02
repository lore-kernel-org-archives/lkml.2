Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1ABUdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 15:33:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35043 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1ABUde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 15:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tx1JiLhnJffufXCcZAoP/FNF3Gurz8smYl1TR+lQsr8X0iUmWSxDinpz6HRyM4B1BF
         EKN1Zduv184bxjE+hyBIxTqMyJDm563JJ0tX//CUk562sRlrfRdjsxyydvgKpR79ewaO
         mQFgsyKqlDR0XzyNM4rw7pfGfZnlUfWCS3sZQ=
MIME-Version: 1.0
In-Reply-To: <20101231215018.GB5012@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20101223001012.GF29368@n2100.arm.linux.org.uk>
	<AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
	<AANLkTikP+JZkN7AjqaNfHY8jZ7bVsV-af=YR=MTdfnNU@mail.gmail.com>
	<20101231215018.GB5012@n2100.arm.linux.org.uk>
Date: Sun, 2 Jan 2011 21:33:34 +0100
Message-ID: <AANLkTiktQbR5cm6qKzrhCBEMqmxOq4WhryoZnQ-kge0g@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/31 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> So, given all these questions (some of which can lead to deadlocks), and
> we're now at -rc8, I see no way that I can sanely (or safely) queue up
> the PL011 UART and PL180 MMCI DMA engine code for this coming merge
> window.  (Sorry Linus.)

Such is life, I am still very happy that you have been taking some
time to dive into this. I will try to work through the points raised
as far as I can...

As for the in-tree PL08x driver I'd say it's doing pretty well for
memcpy() so we could add platform data for that on supported
platforms, then for device transfers we need more elaborative
work.

I will also try to get the Nomadik 8815 up to get some reference
HW for this combo that actually works, including device transfers on
MMCI etc.

Yours,
Linus Walleij
