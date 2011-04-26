Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1DZAyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:54:15 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:38842 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753268Ab1DZAyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:54:14 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB61786.2030307@verizon.net>
Date: Mon, 25 Apr 2011 20:53:26 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, <hjanssen@microsoft.com>,
        <haiyangz@microsoft.com>
Subject: Re: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
References: <4DB60932.6090000@verizon.net> <20110426000024.GB11787@suse.de>
In-Reply-To: <20110426000024.GB11787@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2011 8:00 PM, Greg KH wrote:
> On Mon, Apr 25, 2011 at 07:52:18PM -0400, Peter Foley wrote:
>> This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.
> 
> What is the build error?
> 
> thanks,
> 
> greg k-h


When CONFIG_HYPERV_UTILS=y and CONFIG_NLS=n
the build fails with this error:

 Building modules, stage 2.
  MODPOST 3 modules
ERROR: "utf8s_to_utf16s" [drivers/staging/hv/hv_utils.ko] undefined!
make[3]: *** [__modpost] Error 1
make[2]: *** [modules] Error 2
make[2]: *** Waiting for unfinished jobs....
Kernel: arch/x86/boot/bzImage is ready  (#2)
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
