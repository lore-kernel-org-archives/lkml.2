Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2JRJGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:06:30 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:37046 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2JRJG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:06:28 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Joe Perches <joe@perches.com>, Mischa Jonker <mischa.jonker@synopsys.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "m.d.s.x.jonker@gmail.com" <m.d.s.x.jonker@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: RE: [PATCH v3 1/1] Input: serio - Add ARC PS/2 driver
Thread-Topic: [PATCH v3 1/1] Input: serio - Add ARC PS/2 driver
Thread-Index: AQHNrQzIjOatJmLLgk6xPUb3P2qkT5e+otEAgAAiJkA=
Date: Thu, 18 Oct 2012 09:05:47 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D6019A63@DE02WEMBX1.internal.synopsys.com>
References: <1350549367-11098-1-git-send-email-mischa.jonker@synopsys.com>
	 <1350549367-11098-2-git-send-email-mischa.jonker@synopsys.com>
 <1350550916.3072.61.camel@joe-AO722>
In-Reply-To: <1350550916.3072.61.camel@joe-AO722>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.24.43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

>> +	while (1) {
>infinite loop with bad hardware?
>Perhaps a jiffies timeout?

What do you suggest? Add a counter and limit the maximum number of iterations to an arbitrary number (say 1000)?

Mischa


