Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1HKVEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:04:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1HKVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:04:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=HD0/ZYfReRdm8iao4ObeGmt0URXXij+8agA+XXFCT07iQ3JBEiFEyyiPb+CHPByJU
	Qi8CWGgpj0RsmeVqmWTmA==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CFC@HQMAIL01.nvidia.com>
References: <1313093946-24559-1-git-send-email-dianders@chromium.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CFC@HQMAIL01.nvidia.com>
Date: Thu, 11 Aug 2011 14:04:17 -0700
X-Google-Sender-Auth: cg7b6slQPSe_fHhAmMSYpLwr6EY
Message-ID: <CAD=FV=V5i1ZTGs24hPa2M-VDsr2EFL0_Co7xJf5m07TNbPsMDQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: tegra: fix possible race condition after tx
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 1:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> It's worth pointing out that this patch supersedes a previous attempt to fix
> the same problem, originally posted in https://lkml.org/lkml/2011/4/19/514,
> if I'm understanding correctly.

Yup, you're right.  :)  If people are interested, you can see some
discussion of the differences between the two patches on the Chromium
code review system: <http://gerrit.chromium.org/gerrit/5684>

-Doug
