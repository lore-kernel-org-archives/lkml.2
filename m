Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0IDCE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:04:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0IDCE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:04:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6094"; a="53349055"
Message-ID: <4C81A949.5080707@codeaurora.org>
Date: Fri, 03 Sep 2010 19:04:57 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: markgross@thegnar.org
CC: Kevin Hilman <khilman@deeprootsystems.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
References: <20100827064153.GB3414@gvim.org> <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org> <20100828020540.GB8341@gvim.org> <4C787AA9.4090906@codeaurora.org> <20100828225255.GA12402@gvim.org> <878w3o3p55.fsf@deeprootsystems.com> <20100831184030.GB9305@gvim.org> <4C7D844C.5050403@codeaurora.org> <20100901142804.GA13985@gvim.org> <4C7F1BF2.4050200@codeaurora.org> <20100902140922.GB2818@gvim.org>
In-Reply-To: <20100902140922.GB2818@gvim.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark gross wrote:
> I'll do a patch by monday as an RFC but, I'm wondering if we want it in
> the main line vrs an implementation that scales by bus integrated into
> the driver model per what Kevin has been talking about....

The model Kevin is thinking about will probably need some time and work 
before it's usable. In the meanwhile, can we have this added?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
