Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2LFJYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:24:45 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55590 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2LFJYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:24:43 -0500
Message-ID: <50C06456.7090504@imgtec.com>
Date: Thu, 6 Dec 2012 09:24:38 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 06/44] of/vendor-prefixes: add Imagination Technologies
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-7-git-send-email-james.hogan@imgtec.com> <20121205222824.005C53E0E22@localhost>
In-Reply-To: <20121205222824.005C53E0E22@localhost>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_06_09_24_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 22:28, Grant Likely wrote:
> On Wed, 5 Dec 2012 16:08:24 +0000, James Hogan <james.hogan@imgtec.com> wrote:
>> The "powervr" prefix which is currently described as "Imagination
>> Technologies" isn't really appropriate for non-PowerVR hardware, so
>> deprecate it, changing the description of "powervr" to "PowerVR
>> (deprecated, use img)", and add a separate "img" prefix for "Imagination
>> Technologies Ltd.".
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: devicetree-discuss@lists.ozlabs.org
> 
> Applied, thanks.
> 
> g.

Thanks Grant, I'll drop this patch from the metag patchset.

Cheers
James

