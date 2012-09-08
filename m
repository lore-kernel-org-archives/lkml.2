Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2IHK2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:28:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2IHK2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:28:23 -0400
Message-ID: <504B1DC3.1000604@redhat.com>
Date: Sat, 08 Sep 2012 12:28:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: Jan Beulich <JBeulich@suse.com>, Matt Wilson <msw@amazon.com>,
        "Justin M. Forbes" <jmforbes@linuxtx.org>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com> <5049F4E9.9050306@canonical.com> <504A1A950200007800099D4C@nat28.tlf.novell.com> <20120907142251.GA20096@linuxtx.org> <504A32800200007800099E40@nat28.tlf.novell.com> <504A172B.5020005@canonical.com> <504A347B0200007800099E92@nat28.tlf.novell.com> <504A1D43.2050909@canonical.com>
In-Reply-To: <504A1D43.2050909@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 18:13, Stefan Bader ha scritto:
> This would make it save again _if_ the HV failing to handle the writes to CR4
> (which iirc the kernel code still does when the cpuid bit is set) does have at
> least the patch to mask off the cpuid bits (the one Ian mentioned)

Given how old it is, that's very unlikely.  You can download CentOS 5.0
from http://mirror.stanford.edu/yum/pub/centos/5/isos/x86_64/ or get the
source RPM for the RHEL5.0 kernel (including the Xen hypervisor) at
ftp://ftp.redhat.com/redhat/linux/enterprise/5Client/en/os/SRPMS/kernel-2.6.18-8.el5.src.rpm

Paolo
