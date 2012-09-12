Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2ILV1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:27:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42858 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2ILV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:27:10 -0400
Message-ID: <5050FE28.2080502@wwwdotorg.org>
Date: Wed, 12 Sep 2012 15:27:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
> New revision of the power sequences, taking as usual the feedback that was
> kindly provided about the last version.
> 
> I think now is a good time to discuss integrating this and to start looking for
> a maintainer who would be willing to merge this into his/her tree (I am
> especially thinking about the power framework maintainers, since this is where
> the code is right now.

The other alternative is for you to maintain this going forward; I
believe that would be as simple as:

* Create a patch to add yourself to MAINTAINERS for the
drivers/power/power_seq/ directory.

* Get a kernel.org account, push this patch to a branch there, and add
the branch into linux-next.

* Send a pull request to Linus at the appropriate time.

* Ongoing: Accept any patches, perform any maintenance required, etc.

Does anyone see any issue with Alexandre doing this? Nobody else has
volunteered yet:-)
