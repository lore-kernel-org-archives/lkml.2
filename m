Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2JFPBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:01:19 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:51060 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab2JFPBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:01:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIJAGpHcFBthdBg/2dsb2JhbABFu2CCLgQEgQuBCIIgAQEFeAEQCw0LCRYPCQMCAQIBRQYNAQcBAYgFuTCLT4YQA5tNIooqgm8
Message-ID: <507046D0.8090408@computer.org>
Date: Sat, 06 Oct 2012 16:57:20 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: acme@redhat.com, jolsa@redhat.com, eranian@google.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: Tie lose "perf, tools" ends in Haswell PMU patchkit
References: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 11:22 PM, Andi Kleen wrote:
> This fixes some left over issues in my Haswell PMU patchkit yesterday:
> Ideally applied on top, although there should be no direct dependencies.
> 
> - Now the kernel supplied sysfs aliases can be directly used for cpu.
> This means I can use "tx-aborts" instead of "cpu/tx-aborts/
> - List the kernel events
> - Support using the same names as generic events for kernel events.
> This allows to use cpu/instructions,intx=1/ which was not possible
> before because instructions clashed with the generic name.

I (i.e. me, moi) received only patches 2/3 and 3/3. Is there a patch 1/3?
