Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab0KQI4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:56:03 -0500
Received: from claw.goop.org ([74.207.240.146]:39884 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0KQI4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:56:01 -0500
Message-ID: <4CE398A0.3040105@goop.org>
Date: Wed, 17 Nov 2010 00:56:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, xiyou.wangcong@gmail.com,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com>	<97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>	<4CE3A1060200007800022B04@vpn.id2.novell.com> <4CE397C8.9040901@goop.org>
In-Reply-To: <4CE397C8.9040901@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:52 AM, Jeremy Fitzhardinge wrote:
> But, yes, %z0 sounds interesting.  Is it documented anywhere?  I think
> I've tried to use it in the past and run into gcc bugs.
This one: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=39590

Should be OK in this case because there's no 64-bit values to be seen...

    J
