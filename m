Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab1ANP2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:28:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1ANP2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="877493341"
Message-ID: <4D306B4D.2080909@linux.intel.com>
Date: Fri, 14 Jan 2011 07:27:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jack Stone <jwjstone@fastmail.fm>
CC: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] kernel/async.c: fixing compilation warnings
References: <1295005980-12297-1-git-send-email-viresh.kumar@st.com> <4D304BE6.9070200@fastmail.fm>
In-Reply-To: <4D304BE6.9070200@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2011 5:13 AM, Jack Stone wrote:
> rning: ‘calltime.tv64’ may be used uninitialized in this function

which is clearly a.. gcc funny to be honest. it's a false positive by 
any stretch.

> >  

