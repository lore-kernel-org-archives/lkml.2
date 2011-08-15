Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1HOOKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:10:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1HOOKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:10:04 -0400
Message-ID: <4E4928A1.1050104@redhat.com>
Date: Mon, 15 Aug 2011 07:09:37 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Jay Ren <yongjie.ren@intel.com>,
        stefanha@linux.vnet.ibm.com, KVM General <kvm@vger.kernel.org>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>  <bkwpSnItbJM.A.nx.VNCSOB@chimera>  <CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>  <4E49215A.5080103@redhat.com> <1313416232.32391.13.camel@jaguar>
In-Reply-To: <1313416232.32391.13.camel@jaguar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 06:50 AM, Pekka Enberg wrote:
> Heh, sorry about that, that's the commit SHA mentioned in the above
> bugzilla report. :-)
>
>

Think of it as 'git bisect good' input, rather than output.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

