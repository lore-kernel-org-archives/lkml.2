Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2BARaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:30:23 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49334 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BARaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:30:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
        kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
References: <1326558605.19951.7.camel@lappy>
	<1326561043.5287.24.camel@edumazet-laptop>
	<1326632384.11711.3.camel@lappy>
	<1326648305.5287.78.camel@edumazet-laptop>
	<alpine.DEB.2.00.1201170910130.4800@router.home>
	<1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1201170927020.4800@router.home>
	<1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1201170942240.4800@router.home>
	<alpine.DEB.2.00.1201171620590.14697@router.home>
	<m1bopz2ws3.fsf@fess.ebiederm.org> <m14nvr2vbu.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1201191959540.14480@router.home>
	<m1y5t3yuil.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1201200848040.25882@router.home>
	<CAOJsxLFtvJbNUkXbesXdu39CwyrRrb0yT2jjWtj7m7R0GSr=YA@mail.gmail.com>
Date: Wed, 01 Feb 2012 09:32:47 -0800
In-Reply-To: <CAOJsxLFtvJbNUkXbesXdu39CwyrRrb0yT2jjWtj7m7R0GSr=YA@mail.gmail.com>
	(Pekka Enberg's message of "Wed, 1 Feb 2012 10:05:54 +0200")
Message-ID: <m1sjiuzcg0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX189pMJCK48RbVtN8ud0f/w1wifykRO2zIg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> writes:

> On Fri, Jan 20, 2012 at 4:49 PM, Christoph Lameter <cl@linux.com> wrote:
>> Ok then I guess my last patch is needed to make sysfs operations safe.
>
> Hmm. So is the latter patch needed or not?

Imperfect changelog but yes.

Eric

