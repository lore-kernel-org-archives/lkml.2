Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966075Ab0GPT0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:26:39 -0400
Received: from 8bytes.org ([88.198.83.132]:53839 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759064Ab0GPT0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:26:38 -0400
Date: Fri, 16 Jul 2010 21:26:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KVM timekeeping fixes, V2
Message-ID: <20100716192637.GK23755@8bytes.org>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <20100716131907.GJ23755@8bytes.org> <4C4094E0.7000403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4094E0.7000403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 07:20:32AM -1000, Zachary Amsden wrote:

> I've been very careful to keep nested SVM safe, but I've not got a good
> test for that.  Is there any test suite for the nested case?

To test this you can boot a nested Linux guest and let both, L1 and L2
guest use kvm_clock. Then put some load into the L2 guest and see if the
L2 or the L1 freezes hard (which happens with kvm_clock when the TSC
went backwards for one of them).

	Joerg

