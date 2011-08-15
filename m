Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1HOTII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1HOTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:08:06 -0400
Message-ID: <4E496E7C.30303@redhat.com>
Date: Mon, 15 Aug 2011 12:07:40 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jay Ren <yongjie.ren@intel.com>, stefanha@linux.vnet.ibm.com,
        KVM General <kvm@vger.kernel.org>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera> <bkwpSnItbJM.A.nx.VNCSOB@chimera> <CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com> <4E49215A.5080103@redhat.com> <1313416232.32391.13.camel@jaguar> <4E4928A1.1050104@redhat.com> <20110815163142.0182ce35@schatten.dmk.lab>
In-Reply-To: <20110815163142.0182ce35@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 07:31 AM, Florian Mickler wrote:
> On Mon, 15 Aug 2011 07:09:37 -0700
> Avi Kivity<avi@redhat.com>  wrote:
>
> >  On 08/15/2011 06:50 AM, Pekka Enberg wrote:
> >  >  Heh, sorry about that, that's the commit SHA mentioned in the above
> >  >  bugzilla report. :-)
> >  >
> >  >
> >
> >  Think of it as 'git bisect good' input, rather than output.
> >
>
> Can you post a comment to the bug when Linus pulled that tree?

Most likely kvm.git got that commit from Linus - I don't think the fix 
came from kvm.git.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

