Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab1JFSmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:42:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51377 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1JFSmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:42:43 -0400
Message-ID: <4E8DF505.6050807@zytor.com>
Date: Thu, 06 Oct 2011 11:35:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com> <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com> <4E8DF02B.7010406@goop.org> <20111006183319.GB2505@redhat.com>
In-Reply-To: <20111006183319.GB2505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 11:33 AM, Jason Baron wrote:
> 
> cool. It does add some complication, I think...detecting the 2-byte vs.
> 5-byte, and if done at boot time, possibly taking the undesired
> branch...
> 

It has to be done at build time to be sane, IMO.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

