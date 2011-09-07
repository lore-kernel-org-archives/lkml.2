Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1IGRCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:02:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1IGRCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:02:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=X/Ko0H8z+EMwkIzE1ibzy/ZSIg08DBH6KImYNgdNp+C4UOBIx5ZxyuuMPHg7Mbi3o
	EhKL46It+OJ88/pQ4dHYg==
MIME-Version: 1.0
In-Reply-To: <1315383151.11101.13.camel@twins>
References: <20110906204637.GA31826@quad>
	<1315383151.11101.13.camel@twins>
Date: Wed, 7 Sep 2011 14:55:05 +0200
Message-ID: <CABPqkBRzA32PW2E_wZrESrCQB2KPJqqomZD0M3x4ZBDzWJGi+Q@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        dsahern@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 10:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-09-06 at 22:46 +0200, Stephane Eranian wrote:
>> +static const char *topo_fmt[] = {
>> +       "/sys/devices/system/cpu/cpu%d/topology/core_siblings_list",
>> +       "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list",
>> +       NULL
>> +};
>
> No nodes?
>
To record what information? core/thread siblings or memory stuff?
