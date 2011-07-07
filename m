Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1GGS5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:57:01 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:36360 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab1GGS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:57:00 -0400
Authentication-Results: cdptpa-omtalb.mail.rr.com smtp.user=psusi@cfl.rr.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=8mDY8c80ZOa76EOwICuS+E2YRQjxDgO9xqUnRMONc7w= c=1 sm=0 a=aAvtD6xXQTUA:10 a=c4X0-pCowHEA:10 a=8nJEP1OIZ-IA:10 a=pg4Dpxby4z7sZisWVyJ9NA==:17 a=b4MA72cPqChLun_l-BIA:9 a=wPNLvfGTeEIA:10 a=pg4Dpxby4z7sZisWVyJ9NA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.242.190.170
Message-ID: <4E160179.5090304@cfl.rr.com>
Date: Thu, 07 Jul 2011 14:56:57 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix loopback devices to emit uevent on auto release
References: <4E0912A9.7030403@cfl.rr.com> <20110706154558.1a87054e.akpm@linux-foundation.org>
In-Reply-To: <20110706154558.1a87054e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/2011 6:45 PM, Andrew Morton wrote:
> The patch is missing your Signed-off-by:.  Please review
> Documentation/SubmittingPatches section 12 to see what this means.
> Then, if agreeable, please send us that Signed-off-by:, thanks.

Oops, yes of course.  Please add it, or do you need me to resubmit the 
whole patch?
