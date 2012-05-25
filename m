Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2EYPpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2EYPpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:45:11 -0400
Date: Fri, 25 May 2012 12:39:50 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for Linux 3.5
Message-ID: <20120525153950.GB11355@amt.cnet>
References: <4FBB8FD0.9050804@redhat.com>
 <CA+1xoqfH6i5-FK2jBjTa9u-eV99H237NEJ4TEH1-_n7Y1g3tYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqfH6i5-FK2jBjTa9u-eV99H237NEJ4TEH1-_n7Y1g3tYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 12:13:15PM +0200, Sasha Levin wrote:
> Hi Avi,
> 
> On Tue, May 22, 2012 at 3:08 PM, Avi Kivity <avi@redhat.com> wrote:
> >      KVM guest: make kvm_para_available() check hypervisor bit reading
> > cpuid leaf
> 
> I've reported this patch to cause a hang on hypervisors that don't set
> the hypervisor bit. Can we somehow fix that before this patch actually
> goes into mainline?

Should set the hypervisor bit (see kvm-devel reply) otherwise there are
known causes for crashes.

