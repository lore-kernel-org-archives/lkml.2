Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1DHCEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 22:04:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab1DHCEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 22:04:14 -0400
Message-ID: <4D9E6D19.1040809@codemonkey.ws>
Date: Thu, 07 Apr 2011 21:04:09 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Olivier Galibert <galibert@pobox.com>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu> <20110406101405.GA65838@dspnet.fr> <20110406105547.GA13766@elte.hu>
In-Reply-To: <20110406105547.GA13766@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 05:55 AM, Ingo Molnar wrote:
> Splitting up a project into several trees, often unnecessarily, is a
> self-inflicted wound really.

There's certainly something to this but the bit that surprises me is the 
approaching being taken.

Why not take perf and all the other tools, stick them in their own git 
repos, and use git submodules to track them in the main kernel source 
tree.  It seems like a nicer way to separate git histories while still 
getting the benefits of a shared repository.

Regards,

Anthony Liguori
