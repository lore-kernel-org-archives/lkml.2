Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1EPPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:42:21 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:44765 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126Ab1EPPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:42:20 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-d7-4dd145dbe731
Message-ID: <4DD145D6.2020505@mit.edu>
Date: Mon, 16 May 2011 11:42:14 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fedora 14 not always going to run-level 3?
References: <4DC98489.2060902@candelatech.com>
In-Reply-To: <4DC98489.2060902@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixG6nrnvb9aKvwb6TUhYLHnQwW1zeNYfN
	gcnjzOMZbB6fN8kFMEVx2aSk5mSWpRbp2yVwZTxunM9ecIul4s/Cp0wNjDeYuxg5OSQETCQ2
	fOxkhbDFJC7cW8/WxcjFISSwj1Fi86TlzBDOBkaJq/9vMEE4b5kkdqzczQjSwiugJtG+7j8b
	iM0ioCrx8cs5sLFsAioSHUsfMIHYogKVEpN+7mCFqBeUODnzCQuILSKgIXH0xCIwm1nARuJM
	+zcgm4NDWMBcouciD0hYSEBPYtOSRWDjOQX0JTY1dzKDlDALWEt8210E0Skvsf3tHOYJjIKz
	kCyYhVA1C0nVAkbmVYyyKblVurmJmTnFqcm6xcmJeXmpRbrGermZJXqpKaWbGEGhyynJt4Px
	60GlQ4wCHIxKPLwMzhd9hVgTy4orcw8xSnIwKYnyGgADX4gvKT+lMiOxOCO+qDQntfgQowQH
	s5II75n6C75CvCmJlVWpRfkwKWkOFiVx3pmS6r5CAumJJanZqakFqUUwWRkODiUJXguQoYJF
	qempFWmZOSUIaSYOTpDhPEDD5UBqeIsLEnOLM9Mh8qcYFaXEeRVBEgIgiYzSPLheWGp5xSgO
	9IowryRIFQ8wLcF1vwIazAQ0eNUpkKuLSxIRUlINjFEHHF+bTb15YundfXfVf4T4uhW+WPmo
	9FGJv0eYWeiH0PuOTDF5nrzTvkSsDMlcxjVL/Oa8zNSjxRaP0tbv3Co2dXK8sPP2zJK43l/p
	on6hHvEHt/YXf7p8S0DluspdwyfrvNPd5n/dPz826ZH8IneeelbxxexPVX4GrKmUK/r5uzBA
	8T3DPCWW4oxEQy3mouJEAH3KQdoIAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 02:31 PM, Ben Greear wrote:
> Has anyone else noticed problems with 39-rc1+ sometimes not booting
> into run-level 3? It seems to just go directly to root console prompt
> sometimes. Seems it was easier to reproduce on -rc1 and early more
> buggy kernels, for what that's worth..

I don't know exactly which version it was, but when I was bisecting some 
unrelated breakage in 2.6.39-rc7, some of the test kernels got stuck in 
some early systemd stage (F15 beta) and failed to make progress.  But 
I've never seen this on new kernels or on 2.6.38.y.

--Andy

>
> Ben
>

