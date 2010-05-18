Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0ERVb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:31:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53382 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0ERVbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:31:53 -0400
Message-ID: <4BF30732.3080906@zytor.com>
Date: Tue, 18 May 2010 14:31:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using alternatives
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF26.9050701@zytor.com> <1274217067.2485.9.camel@edumazet-laptop>
In-Reply-To: <1274217067.2485.9.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 02:11 PM, Eric Dumazet wrote:
> 
> I use many different machines to compile kernels, and found this one
> using gcc-3.4.6, but still running original 2.6.9.something RHEL
> kernel ;)
> 

OK, so this is "testing only, not actually using."

I guess I'm trying to figure out if *anyone* would actually care if gcc
3.x support is discontinued.

	-hpa
