Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2FMNc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:32:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2FMNc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:32:57 -0400
Message-ID: <1339594368.8980.41.camel@twins>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 13 Jun 2012 15:32:48 +0200
In-Reply-To: <CAKfTPtCyV389OTrun5Oyn8RCsDagza95wdmWr=r9poMiYrU0Mg@mail.gmail.com>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	 <CAORVsuWqWt0pJfewymh_ydAH61-uPsO0M7m7Gs4N3zJY=Vo9ZA@mail.gmail.com>
	 <CAKfTPtBc-KuDg_1qe04TfYS4+66qQoiHCJQbCF9gnhga5ociow@mail.gmail.com>
	 <CAP245DXEOGLe1jq2Wj0rNW5qea63UyJu2jOvwV65Y4B9LLoQtg@mail.gmail.com>
	 <1339591666.8980.26.camel@twins>
	 <CAKfTPtCyV389OTrun5Oyn8RCsDagza95wdmWr=r9poMiYrU0Mg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:29 +0200, Vincent Guittot wrote:
> In fact, there is 2 tracks, one for a power aware scheduler and one
> for setting the capacity of each core of a big.LITTLE system. This
> patch is for the latter and is not directly link to the power because
> the default/performance mode of the scheduler should also take
> advantage of this information 

Fair enough.. can you include a little blurp in the changelog on how
this affects the capacity stuff for big.little and if that works as
desired due to these patches?


