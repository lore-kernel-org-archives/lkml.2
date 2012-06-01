Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2FAHQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 03:16:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:63329 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab2FAHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 03:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173569767"
Message-ID: <4FC86C59.5030409@linux.intel.com>
Date: Fri, 01 Jun 2012 15:16:41 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: Only register mce_decode_chain once
References: <1338488391-20755-1-git-send-email-roland@kernel.org> <4FC82AFB.6020209@linux.intel.com> <CAG4TOxNUjL6EbOFKy12=deBNZGkwezkx3=tu9a1U6NpUGTs3CA@mail.gmail.com>
In-Reply-To: <CAG4TOxNUjL6EbOFKy12=deBNZGkwezkx3=tu9a1U6NpUGTs3CA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/1 14:04, Roland Dreier 写道:
>> Hi, please refer this: https://lkml.org/lkml/2012/5/8/62
> 
> Yes, your fix looks identical.  However your changelog makes it
> sound a bit less severe that it is: on my system at least, it is
> an immediate hard hang the first time sb_edac is loaded, rather
> than requiring module unload or any memory errors to trigger.
> 
> Anyway I think the fix needs to get merged right away, and your
> patch is fine with me.
> 
> - R. --

Mauro told me some days before he will put this patch(with others) on
another tree, test and then merge it.
