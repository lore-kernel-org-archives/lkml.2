Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1BGV0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:26:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37425 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1BGV0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:26:20 -0500
Message-ID: <4D506363.4030707@zytor.com>
Date: Mon, 07 Feb 2011 13:25:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: John Villalovos <john.l.villalovos@intel.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        John Villalovos <jvillalo@redhat.com>, prarit@redhat.com
Subject: Re: [PATCH 1/1 V2] x86, apic: Make "broken BIOS!!" messages unique
References: <20110207135843.GA10121@linuxjohn3.jf.intel.com>
In-Reply-To: <20110207135843.GA10121@linuxjohn3.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 05:58 AM, John Villalovos wrote:
> 
> The 'inconceivable' messages are because it should not be possible to reach
> those code paths.
> 

More standard terminology would be "invalid" or "impossible".
"Inconceivable" sounds like a combination of legal values which just
don't make sense.

	-hpa
