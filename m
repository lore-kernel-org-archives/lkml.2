Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1ANSjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:39:17 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40217 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757763Ab1ANSjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:39:16 -0500
X-Sasl-enc: uWZ3PlFteRtbbR7S5+d5cD1eiyrIGuQf4tCYAMGuM0s9 1295030355
Message-ID: <4D309851.4020503@fastmail.fm>
Date: Fri, 14 Jan 2011 18:39:13 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] kernel/async.c: fixing compilation warnings
References: <1295005980-12297-1-git-send-email-viresh.kumar@st.com> <4D304BE6.9070200@fastmail.fm> <4D306B4D.2080909@linux.intel.com>
In-Reply-To: <4D306B4D.2080909@linux.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2011 15:27, Arjan van de Ven wrote:
> On 1/14/2011 5:13 AM, Jack Stone wrote:
>> rning: ‘calltime.tv64’ may be used uninitialized in this function
> 
> which is clearly a.. gcc funny to be honest. it's a false positive by
> any stretch.
> 

Agreed. Who should merge this?

Thanks,

Jack
