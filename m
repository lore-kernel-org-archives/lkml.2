Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1GVSh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:37:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1GVSh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:37:27 -0400
Message-ID: <4E29C1DF.9080705@zytor.com>
Date: Fri, 22 Jul 2011 11:30:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Venkatesh Pallipadi <venki@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable]
References: <20110722091151.GA4004@tiehlicka.suse.cz> <4E29A20C.70402@zytor.com> <20110722173102.GA26935@tiehlicka.suse.cz>
In-Reply-To: <20110722173102.GA26935@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 10:31 AM, Michal Hocko wrote:
> 
> Thanks for the clarification!
> What do you think about fixing the nopat with STRICT_DEVMEM like the
> patch does?
> 

>From what I gather from your patch, the issue is that STRICT_DEVMEM
isn't being honored with nopat?  This is an obvious bug and should be fixed.

	-hpa
