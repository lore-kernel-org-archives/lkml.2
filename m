Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2GBMbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:31:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GBMbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:31:33 -0400
Message-ID: <1341232257.23484.10.camel@twins>
Subject: Re: [PATCH v3 3/5] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com
Date: Mon, 02 Jul 2012 14:30:57 +0200
In-Reply-To: <CAKfTPtAHvKcdgiL4xx-zBJU5DZ5YwGUbjgtoh9a1tf_C2Amg5w@mail.gmail.com>
References: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
	 <1340205562-7653-4-git-send-email-vincent.guittot@linaro.org>
	 <1341220283.28750.138.camel@twins>
	 <CAKfTPtAHvKcdgiL4xx-zBJU5DZ5YwGUbjgtoh9a1tf_C2Amg5w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 14:11 +0200, Vincent Guittot wrote:
> max / (min + max) * 2^11 so the cpu_scale is smaller than 2^11  as min
> is never equal to 0 

D'0h right.. I think I confused the middle thing with avg again. 
