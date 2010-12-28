Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0L1Adz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:33:55 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45969 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0L1Ady (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qU7nxihTku0IFdIbmkcE8DhlIWJ1+rJwG38Tu9v9RDuhCUSfuhhf5MZ10j29cPqV7e
         avCVF9VKV/8n9d+WDsVX61DguMyUmWmkrrDYtob7HDGObIBm51djuL+z0JZ+RY3RcZOX
         viKtfgj4TIv5smT8AzHadGZYo+NJoMpxAY96M=
MIME-Version: 1.0
In-Reply-To: <20101223123028.GI3636@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<AANLkTinOMOkY6AUW8Z6FWMMWU9u0_sNjA2r_31u9-A8v@mail.gmail.com>
	<20101223123028.GI3636@n2100.arm.linux.org.uk>
Date: Tue, 28 Dec 2010 01:33:54 +0100
Message-ID: <AANLkTimomORGDf7yoyraiSnXy4OJciPud-POxk24eRGE@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> I'm currently splitting my dirty patch, and attacking this driver to
> clean up some of it into a more reasonable shape, so this is one area
> which I'm going to be sorting out.

Thanks Russell, much appreciated. I'll be quick to review and ACK
any patches hopefully.

Yours,
Linus Walleij
