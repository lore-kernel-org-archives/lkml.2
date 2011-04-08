Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1DHI1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:27:20 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55472 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1DHI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:27:18 -0400
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, asias.hejun@gmail.com, gorcunov@gmail.com
In-Reply-To: <4D9EBBC3.2040803@siemens.com>
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>
	 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	 <4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>
	 <4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>
	 <4D9E6F6E.9050709@codemonkey.ws>
	 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
	 <4D9EBBC3.2040803@siemens.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 08 Apr 2011 11:27:16 +0300
Message-ID: <1302251236.27918.31.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Fri, 2011-04-08 at 09:39 +0200, Jan Kiszka wrote:
> I agree that it's easy to change 2kSomething LOC for this. But if you
> now wait too long designing in essential features like SMP, a scalable
> execution model, and - very important - portability (*), it can get
> fairly painful to fix such architectural deficits later on. How long did
> it take for Linux to overcome the BKL? QEMU is in the same unfortunate
> position.

Yup, and we're taking your feedback seriously (and are thankful for
it!). We're hoping to look at SMP in the near future - help is
appreciated!

			Pekka

