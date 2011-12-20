Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1LTIwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:52:20 -0500
Received: from claw.goop.org ([74.207.240.146]:57481 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1LTIwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:52:11 -0500
Message-ID: <4EF04CB7.7040402@goop.org>
Date: Tue, 20 Dec 2011 00:52:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        paulus <paulus@samba.org>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <1324309901.24621.14.camel@twins>
In-Reply-To: <1324309901.24621.14.camel@twins>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 07:51 AM, Peter Zijlstra wrote:
> Use paravirt ticket locks

I guess it's time I reposted that series.

    J
