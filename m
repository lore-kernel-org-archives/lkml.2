Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2GTRSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:18:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab2GTRSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:18:33 -0400
Message-ID: <500992D3.8080108@zytor.com>
Date: Fri, 20 Jul 2012 10:18:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120720171002.GE13032@tassilo.jf.intel.com>
In-Reply-To: <20120720171002.GE13032@tassilo.jf.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 10:10 AM, Andi Kleen wrote:
> 
> And please use rdmsrl(), rdmsr() is so 90ies
> 

rdmsr()/wrmsr() make more sense in cases like this where the upper and
lower halves of the MSR actually contain separate data.

	-hpa

