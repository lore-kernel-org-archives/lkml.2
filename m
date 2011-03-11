Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1CKSaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:30:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1CKSaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:30:08 -0500
Message-ID: <4D7A6A26.5000501@redhat.com>
Date: Fri, 11 Mar 2011 19:29:58 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Andi Kleen <ak@linux.intel.com>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
References: <20110308164508.GA8729@darkside.kls.lan> <20110310165730.GC20504@alboin.amr.corp.intel.com> <20110310175411.GB25027@darkside.kls.lan> <20110311011842.GA5698@alboin.amr.corp.intel.com> <20110311180334.GA11382@darkside.kls.lan>
In-Reply-To: <20110311180334.GA11382@darkside.kls.lan>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 07:03 PM, Mario 'BitKoenig' Holbe wrote:

>> You probably need to find some way
>> to make pcrypt (parallel crypt layer) work for dmcrypt. That may
>> actually give you more speedup too than your old hack because
>> it can balance over more cores. 

dmcrypt is already using async crypto interface, it is ready
for parallelization on this level.

Perhaps the problem is that pcrypt is not yet implemented for needed
algorithms?

Milan

