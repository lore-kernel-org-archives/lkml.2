Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1KGUoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:44:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1KGUn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:43:59 -0500
References: <20111107194838.GA23558@alea.gnuu.de> <4EB83CB0.1090304@redhat.com>
In-Reply-To: <4EB83CB0.1090304@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8G4)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <7CF7606D-9D49-4D6F-AAD3-253D2F5F48F2@suse.de>
Cc: =?utf-8?Q?J=C3=B6rg_Sommer?= <joerg@alea.gnuu.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
X-Mailer: iPhone Mail (8G4)
From: Alexander Graf <agraf@suse.de>
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Date: Mon, 7 Nov 2011 21:43:26 +0100
To: Avi Kivity <avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.11.2011, at 21:16, Avi Kivity <avi@redhat.com> wrote:

> On 11/07/2011 09:48 PM, Jörg Sommer wrote:
>> Hello everybody,
>> 
>> I'm trying to build the kernel with the git commit-id
>> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
>> 
> 
> Alex, can we set up some buildbots for the ppc family, feeding on
> kvm.git master/next?

We already have a ppc box for qemu builds, so all we need is someone knowledgable in buildbot to also fetch kvm.git and build it in parallel to qemu.git :)

Alex

> 
