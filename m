Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2LAWLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 17:11:40 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:51850 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab2LAWLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 17:11:39 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 01 Dec 2012 23:11:34 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121031 Icedove/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
References: <50A78AA9.5040904@iskon.hr> <20121130225200.GB6021@htj.dyndns.org> <20121130225545.GC6021@htj.dyndns.org> <50B9E4C1.2050002@iskon.hr> <20121201143852.GA2685@htj.dyndns.org> <50BA3A2E.9020303@iskon.hr> <20121201191321.GC2685@htj.dyndns.org>
In-Reply-To: <20121201191321.GC2685@htj.dyndns.org>
Message-ID: <50BA8096.8060003@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121201 #8576098, check: 20121201 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 39763 [Dec 02 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 20:13, Tejun Heo wrote:
> Hello,
>
> On Sat, Dec 01, 2012 at 06:11:10PM +0100, Zlatko Calusic wrote:
>> Sure. Please clarify, should I apply it on top of the previous one
>> or standalone?
>
> It's a replacement, so by itself.
>
> Thanks!
>

I have good news, again. The kernel with the patch applied has been 
running flawlessly for the last hour. No excess context switching.

Regards,
-- 
Zlatko
