Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0C1UzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:55:21 -0400
Received: from mga07.intel.com ([143.182.124.22]:1654 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755216Ab0C1UzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,324,1267430400"; 
   d="scan'208";a="259626318"
Message-ID: <4BAFC232.8010404@linux.intel.com>
Date: Sun, 28 Mar 2010 22:55:14 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, David Airlie <airlied@linux.ie>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] drm: sysfs files error handling
References: <20100328112438.GK5069@bicker>
In-Reply-To: <20100328112438.GK5069@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

, Dan Carpenter wrote:
>
> In the original code we used "j" as an iterator but we used "i" as an
> index.
>
> -               for (j = 0; j<  i; j++)
> -                       device_remove_file(&connector->kdev,
> -&connector_attrs[i]);

I guess this really should be a attribute group anyways?

Typically when there's such a open coded loop it means the wrong
interfaces are being used.

-Andi

