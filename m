Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0G1Ush (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:48:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34577 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab0G1Usg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:48:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49112288"
Message-ID: <4C5097A3.80000@codeaurora.org>
Date: Wed, 28 Jul 2010 13:48:35 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/4] Checkpatch: warn about unexpectedly long msleep's
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>	<1280345587-19725-5-git-send-email-ppannuto@codeaurora.org> <20100728132457.06b0c279.akpm@linux-foundation.org>
In-Reply-To: <20100728132457.06b0c279.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +# warn about unexpectedly long msleep's
>> +		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
>> +			if ($1 < 20) {
>> +				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/delays.txt\n" . $line);
> 
> Should be timers-howto.txt?
> 
> 

Yes, will fix

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
