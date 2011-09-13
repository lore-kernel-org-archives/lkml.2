Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1IMGHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:07:16 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:54568 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab1IMGHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:07:15 -0400
Message-ID: <4E6EF310.7060603@profihost.ag>
Date: Tue, 13 Sep 2011 08:07:12 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: system freezing with 3.0.4
References: <4E69A496.9040707@profihost.ag> <20110912201606.GA24927@infradead.org>
In-Reply-To: <20110912201606.GA24927@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Fri, Sep 09, 2011 at 07:31:02AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi list,
>>
>> here's an updated post of my one yesterday.
>>
>> We've updated some systems from 2.6.32 to 3.0.4 vanilla kernel.
>> Since then we're expecting freezes every now and then. All in memory
>> apps are still working but nothing which reads or writes from or to
>> disk (at least it seems like that).
>
> What storage driver(s) do you use?

aacraid - but i'm also seeing this on other systems.

Stefan
