Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1DHOjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:39:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60718 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab1DHOjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:39:46 -0400
Date: Fri, 8 Apr 2011 10:39:32 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "asias.hejun@gmail.com" <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110408143932.GA21044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Pekka Enberg <penberg@kernel.org>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"aarcange@redhat.com" <aarcange@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"asias.hejun@gmail.com" <asias.hejun@gmail.com>
References: <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <4D9E6F6E.9050709@codemonkey.ws>
 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
 <4D9EBBC3.2040803@siemens.com>
 <1302251236.27918.31.camel@jaguar>
 <4D9ED146.7040004@siemens.com>
 <BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 01:32:24PM +0400, Cyrill Gorcunov wrote:
> 
> It seems there is a misunderstanding. KVM-tool is quite far from been KVM
> replacement (if ever). And what we're doing -- extremely tiny/small HV which
> would help us to debug/test kernel code.

If that's true, then perhaps the command-line invocation shouldn't be
named "kvm"?  The collision on the name of executable that claims that
it will replace the kvm shipped in qemu seems to make the claim quite
clearly that it's going to replace qemu's kvm in short order?

	     	  	   	   	      	 - Ted
