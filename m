Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1J1J2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:28:06 -0400
Received: from smtp.nokia.com ([147.243.1.48]:56340 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1J1J2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:28:05 -0400
Subject: HSI framework for linux-next
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 12:27:46 +0300
Message-ID: <1319794066.28874.22.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I have been working in an HSI framework for linux:

https://lkml.org/lkml/2011/6/10/280

The framework is in good shape and is currently being used for some
people so we would like it to see it integrated, if possible, for 3.3

Latest discussion for integration:
https://lkml.org/lkml/2011/10/20/177

Therefore, could you add the following tree to linux-next ? 
	git@gitorious.org:kernel-hsi/kernel-hsi.git for-next

Currently the framework does not have any HSI/SSI controller driver, but
myself I am working on an SSI OMAP one, which needs some changes to get
full acceptance. So hopefully I will have the changes done and acked on
time.
There are also other people preparing their controllers for integration
(see the integration discussion)

Thanks and br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

