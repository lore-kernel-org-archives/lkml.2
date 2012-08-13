Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2HMUof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:44:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2HMUoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:44:34 -0400
Message-ID: <5029671A.70402@zytor.com>
Date: Mon, 13 Aug 2012 13:44:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
References: <20120727181436.GA6271@linux.vnet.ibm.com>
In-Reply-To: <20120727181436.GA6271@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 11:14 AM, Kent Yoder wrote:
> Hi James,
> 
> Please pull from this new branch and ignore the 7-25-12 branch. This
> new branch includes fixes for comments by hpa. I've also included one
> additional patch from [1] to close a race and prevent possibly sensitive
> data from being free'd before being zeroed. I'm attaching this entire
> diff here since my fixes for hpa's comments aren't public yet.
> 
> Thanks,
> Kent
> 
> [1] https://lkml.org/lkml/2012/7/25/431
> 

Hi guys,

I was wondering what the status on this tree is?

	-hpa

