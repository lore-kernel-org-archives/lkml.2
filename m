Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2GTAFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:05:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43817 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2GTAFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:05:35 -0400
Message-ID: <50089EB9.2090109@zytor.com>
Date: Thu, 19 Jul 2012 16:56:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Borislav Petkov <bp@amd64.org>, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, luto@mit.edu, yinghai@kernel.org, riel@redhat.com,
        avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 7/9] x86/tlb: enable tlb flush range support for x86
References: <1340845344-27557-1-git-send-email-alex.shi@intel.com> <1340845344-27557-8-git-send-email-alex.shi@intel.com> <20120719122057.GA21666@aftab.osrc.amd.com> <50089DC2.5040508@intel.com>
In-Reply-To: <50089DC2.5040508@intel.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 04:52 PM, Alex Shi wrote:
> 
> Sure, it is a bug, the fix had sent:
> https://lkml.org/lkml/2012/7/6/350
> 

Could you please re-send that as a clean patch?

	-hpa

