Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2EHG72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:59:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:25633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2EHG7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141274230"
Message-ID: <4FA8C44A.3070700@linux.intel.com>
Date: Tue, 08 May 2012 14:59:22 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: mchehab@redhat.com, bp@amd64.org, tony.luck@intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3] edac: avoid mce decoding crash after edac driver unloaded
References: <1336374233-11482-1-git-send-email-gong.chen@linux.intel.com> <1336395950-12430-1-git-send-email-gong.chen@linux.intel.com> <20120507155202.GA3934@kroah.com>
In-Reply-To: <20120507155202.GA3934@kroah.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
>  stable kernel tree.  Please read 
> Documentation/stable_kernel_rules.txt for how to do this properly.
> 
> </formletter> -- To unsubscribe from this list: send the line 
> "unsubscribe linux-edac" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 

Hi, Greg

Do you mean I need to add some information in my patch as below:

Cc: <stable@vger.kernel.org> # 3.3.y:
Cc: <stable@vger.kernel.org> # 3.2.y: 3653ada: x86, mce: Add wrappers
Cc: <stable@vger.kernel.org> # 3.2.y:


For 3.3.y, commit 3653ada has been there so it is not necessary. Is it
OK to send one patch to two -stable trees?

