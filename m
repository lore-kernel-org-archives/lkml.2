Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2GINLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:11:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:5993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab2GINLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:11:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="169207702"
Message-ID: <4FFAD870.7090209@linux.intel.com>
Date: Mon, 09 Jul 2012 06:11:12 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Paul Bolle <pebolle@tiscali.nl>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
References: <1341583705.4655.18.camel@amber.site>  <4FF71F1C.4040608@xenotime.net> <1341597439.4655.23.camel@amber.site>  <4FF72733.8000007@linux.intel.com>  <1341605949.22584.6.camel@x61.thuisdomein> <1341820572.4605.35.camel@amber.site>
In-Reply-To: <1341820572.4605.35.camel@amber.site>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2012 12:56 AM, Jean Delvare wrote:

> Back to my initial question, am I right to assume that
> CONFIG_CC_STACKPROTECTOR is no longer experimental and can be enabled in
> distribution kernels?

it HAS been enabled in distribution kernels for YEARS.
so yes.

