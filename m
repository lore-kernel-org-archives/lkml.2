Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2JPJvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:51:12 -0400
Received: from plane.gmane.org ([80.91.229.3]:51046 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2JPJvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:51:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: Kernel panic on CentOS
Date: Tue, 16 Oct 2012 09:50:57 +0000 (UTC)
Message-ID: <k5jam0$mrd$1@ger.gmane.org>
References: <507C66E0.6070802@gmail.com>
	<20121016001007.35aa5bbb@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 99-30-176-128.lightspeed.sndgca.sbcglobal.net
User-Agent: Pan/0.136 (I'm far too busy being delicious; GIT 926a150
	git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 00:10:07 +0100, Alan Cox wrote:

> On Mon, 15 Oct 2012 21:41:20 +0200 "Mikko C." <mikko.cal@gmail.com>
> wrote:
> 
>> Hi,
>> we keep getting kernel panics on our CentOS 6.3 server, running about
>> 40 KVM virtual machines.
>> 
>> Here's the screenshot of the trace: http://i.imgur.com/yaRyF.png
>> 
>> # uname -a Linux srv010 2.6.32-71.el6.x86_64 #1 SMP Fri May 20 03:51:51
>> BST 2011 x86_64 x86_64 x86_64 GNU/Linux

> You are in the wrong place - the Red Hat enterprise kernels deviate a
> lot from upstream and are very old. Really you need to go back to the
> Centos community with it.
> 
> Alan

This is more like general info/tip: anyone wishing to test the latest 
mainline/stable kernels from kernel.org on RHEL systems can do so by 
installing kernel-ml [1] from the ELRepo Project. As of today, 3.6.2 and 
3.0.46 are available for RHEL-6.

Akemi

[1] http://elrepo.org/tiki/kernel-ml

