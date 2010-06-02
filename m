Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0FBHxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:53:24 -0400
Received: from mga06.intel.com ([134.134.136.21]:24915 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289Ab0FBHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:53:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,346,1272870000"; 
   d="scan'208";a="523209178"
Message-ID: <4C060DEB.9020507@linux.intel.com>
Date: Wed, 02 Jun 2010 09:53:15 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <4C04AB6E.1080305@linux.intel.com> <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Almost every CPU is "very slow" so that it lags behind disk when
> encrypting. CPUs with hardware AES may be the exception.

Behind disk??

You're not serious?

-Andi

