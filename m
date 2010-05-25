Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0EYJmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:42:19 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:57293 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756267Ab0EYJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:42:18 -0400
Message-ID: <4BFB9B6E.9090402@example.com>
Date: Tue, 25 May 2010 11:42:06 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Divyesh Shah <dpshah@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
In-Reply-To: <1274777422.5882.591.camel@twins>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11220436996962546063
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2010 10:50, Peter Zijlstra wrote:

> Clearly nobody tested this, and its terribly broken to boot.
>
> I guess they want something like:

Patch applied, building now. Why don't you merge this into the kernel 
tree? Or should I apply this patch each time manually?

Thanks, regards,

Piotr Hosowicz

-- 
Z Allegro: PRZEDMIOTEM AUKCJI JEST NOKIA 6210, ODDA£EM JA SPEC-
JALISCIE DO WGRANIA JAKIEGOS SOFTU Z NOWYMI BAJERAMI, NO I MAM
BAJER NA WY¦WIETLACZU W POSTACI NAPISU "CONTACT SERVICE".
NP: Chickenfoot - Down The Drain
NB: 2.6.34-20100524-1752
