Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2JPTCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:02:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:48583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2JPTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:02:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="234673334"
Message-ID: <507DAF3C.90903@zytor.com>
Date: Tue, 16 Oct 2012 12:02:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Shuah Khan <shuah.khan@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        shuahkhan@gmail.com, andreas.herrmann3@amd.com,
        borislav.petkov@amd.com
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
References: <6ec48b96-afab-4c8b-ab74-2c640c2a161b@blur> <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur> <1350409738.2785.30.camel@lorien2> <20121016182621.GA10857@jshin-Toonie>
In-Reply-To: <20121016182621.GA10857@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:26 AM, Jacob Shin wrote:
> 
> HPA, it would be great if we can first get this patch upstream, and also
> into the stable trees .. and after that, we can work on getting Yinghai's
> mm refactoring in ..
> 

I'll be back from travels tomorrow, I'll look at it then.

	-hpa


