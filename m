Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1HJVrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1HJVrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:47:24 -0400
Subject: Re: [PATCH] powerpc/kvm: fix build errors with older toolchains
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1313002585.1674.13.camel@pasglop>
Date: Wed, 10 Aug 2011 23:46:56 +0200
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <329D535D-4A7C-4EE8-9342-EFE2D0EEBE81@suse.de>
References: <1312397755-15737-1-git-send-email-nacc@us.ibm.com> <4E429CAD.5050000@suse.de> <1313002585.1674.13.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.08.2011, at 20:56, Benjamin Herrenschmidt wrote:

> On Wed, 2011-08-10 at 16:58 +0200, Alexander Graf wrote:
>> On 08/03/2011 08:55 PM, Nishanth Aravamudan wrote:
>>> On a box with gcc 4.3.2, I see errors like:
>>> 
>>> arch/powerpc/kvm/book3s_hv_rmhandlers.S:1254: Error: Unrecognized opcode: stxvd2x
>>> arch/powerpc/kvm/book3s_hv_rmhandlers.S:1316: Error: Unrecognized opcode: lxvd2x
>> 
>> Paul, mind to ack?
> 
> I merged it already :-) It was trivial & annoying enough.

Alright then, I won't touch it :)


Alex

