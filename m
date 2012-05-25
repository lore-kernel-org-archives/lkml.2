Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2EYKNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:13:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37184 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2EYKNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <4FBB8FD0.9050804@redhat.com>
References: <4FBB8FD0.9050804@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 25 May 2012 12:13:15 +0200
Message-ID: <CA+1xoqfH6i5-FK2jBjTa9u-eV99H237NEJ4TEH1-_n7Y1g3tYw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for Linux 3.5
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Tue, May 22, 2012 at 3:08 PM, Avi Kivity <avi@redhat.com> wrote:
>      KVM guest: make kvm_para_available() check hypervisor bit reading
> cpuid leaf

I've reported this patch to cause a hang on hypervisors that don't set
the hypervisor bit. Can we somehow fix that before this patch actually
goes into mainline?
