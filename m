Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2L0Pmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:42:49 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:52154 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2L0Pmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:42:47 -0500
X-Remote-IP: 213.191.128.133
Date: Thu, 27 Dec 2012 16:42:39 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <50D24AF3.1050809@iskon.hr> <50D24CD9.8070507@iskon.hr> <CAJd=RBCQN1GxOUCwGPXL27d_q8hv50uHK5LhDnsv7mdv_2Usaw@mail.gmail.com>
In-Reply-To: <CAJd=RBCQN1GxOUCwGPXL27d_q8hv50uHK5LhDnsv7mdv_2Usaw@mail.gmail.com>
X-Spam-Score: ##
Message-ID: <50DC6C6F.6050703@iskon.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: do not sleep in balance_pgdat if there's no i/o congestion
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121227 #8894572, check: 20121227 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40781 [Dec 27 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 12:51, Hillf Danton wrote:
> On Thu, Dec 20, 2012 at 7:25 AM, Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:
>>   static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>>                                                          int *classzone_idx)
>>   {
>> -       int all_zones_ok;
>> +       struct zone *unbalanced_zone;
>
> nit: less hunks if not erase that mark
>
> Hillf

This one left unanswered and forgotten because I didn't understand what 
you meant. Could you elaborate?

-- 
Zlatko
