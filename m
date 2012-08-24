Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab2HXRCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab2HXRCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:02:16 -0400
Message-ID: <5037B36A.8000209@redhat.com>
Date: Fri, 24 Aug 2012 13:01:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>
Subject: KS/Plumbers: c-state governor BOF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After talking about my RFC patches to the c-state governor with
Matthew and Arjan, it is clear that the whole concept of how
things are done could use some more discussion.

Since a good number of us will be in San Diego next week, at
Kernel Summit / Plumbers / etc, I will organize a c-state
governor BOF for those who are interested.

Things to think about:
- what should the c-state governor do?
- how to best predict the future?
- what kinds of odd workloads do we need to accomodate?

I will talk to the LF people about getting space for such a
BOF (probably after a mini-summit is done with a room, or a
spare room), and will announce when and where such a BOF will
take place.

Watch whatever board is used to announce BOFs next week :)

-- 
All rights reversed
