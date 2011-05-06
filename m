Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1EFRi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:38:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34639 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1EFRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:38:26 -0400
Date: Fri, 6 May 2011 19:38:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        ying.huang@intel.com
Subject: Re: [Bug] Kdump does not work when panic triggered due to MCE
Message-ID: <20110506173825.GK11636@one.firstfloor.org>
References: <20110506165412.GB2719@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506165412.GB2719@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Has anybody tested this before? Or have found kdump working when fatal
> MCEs have actually occurred?

Ying did some testing. mce-test has test cases for kdump.

My guess is you injected the error into some area used by the kexec
code or boot up path of the kexec kernel.

-Andi
