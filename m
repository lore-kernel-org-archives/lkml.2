Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285Ab2EKXwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:52:09 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:55363 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761227Ab2EKXwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:52:01 -0400
Message-ID: <4FADA630.1080806@xenotime.net>
Date: Fri, 11 May 2012 16:52:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: linux-next: Tree for May 11 (perf_event_amd.c)
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
In-Reply-To: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 11:27 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 201205010:



when CONFIG_LOCAL_APIC is not enabled:

perf_event_amd.c:(.text+0x11530): undefined reference to `get_ibs_caps'


-- 
~Randy
