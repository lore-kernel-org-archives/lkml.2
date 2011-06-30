Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1F3RMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:12:40 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33965 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1F3RMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:12:39 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzHuK2TMg==
X-RZG-CLASS-ID: mo00
Message-ID: <4E0CAE86.6020901@hartkopp.net>
Date: Thu, 30 Jun 2011 19:12:38 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ram Pai <linuxram@us.ibm.com>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>	<4E0CACB7.7040709@hartkopp.net> <20110630100705.2d65656c@jbarnes-desktop>
In-Reply-To: <20110630100705.2d65656c@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.06.2011 19:07, Jesse Barnes wrote:
> On Thu, 30 Jun 2011 19:04:55 +0200
> Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> 
>> On 30.06.2011 10:09, Ram Pai wrote:
>>> Multiple attempts to dynamically reallocate pci resources have unfortunately
>>> lead to regressions. Though we continue to fix the regressions and fine tune the
>>> dynamic-reallocation behavior, we have not reached a acceptable state yet.
>>>
>>> This patch provides a interim solution. It disables dynamic-reallocation; by
>>> default, with the ability to enable it through pci=realloc kernel command line
>>> parameter.
>>
>> What is the advantage of creating an 'interim' kernel parameter instead of
>> reverting the problematic commit and queue up a proper solution for 3.1 ?
>>
>> A kernel parameter needs to be observed, documented and set appropriately.
>>
>> I would prefer to have an automatic solution - if not in 3.0 then in 3.1 ...
> 
> Yeah, we all want an automatic solution, but we still haven't been able
> to achieve one.  My hope is that a parameter will let us keep the code
> upstream for Ram and others to keep fixing, then we can move to using
> it by default in some future release.  Keeping the code upstream but
> behind a param should make development easier; at least that's the goal.

What's wrong with the "[PATCH 0/4 v2] PCI: fix cardbus and sriov regressions"?
To me it looked good - or don't you trust that fix right now?

Regards,
Oliver
