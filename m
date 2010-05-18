Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0ERWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:19:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55192 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab0ERWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:19:19 -0400
Message-ID: <4BF31262.1090303@us.ibm.com>
Date: Tue, 18 May 2010 15:19:14 -0700
From: Nivedita Singhvi <niv@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: dvhltc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Michael Ellerman <ellerman@au1.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>
In-Reply-To: <4BF30C32.1020403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian King wrote:
> Is IRQF_NODELAY something specific to the RT kernel? I don't see it in mainline...

Yep, this is RT only.

thanks,
Nivedita
