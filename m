Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2IGPwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:52:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60660 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2IGPwF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 7 Sep 2012 11:52:05 -0400
Message-Id: <504A347B0200007800099E92@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 16:52:59 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefan Bader" <stefan.bader@canonical.com>
Cc: "Matt Wilson" <msw@amazon.com>, "Justin M. Forbes" <jmforbes@linuxtx.org>,
        <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen
 hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <504A05B00200007800099C7B@nat28.tlf.novell.com>
 <5049F4E9.9050306@canonical.com>
 <504A1A950200007800099D4C@nat28.tlf.novell.com>
 <20120907142251.GA20096@linuxtx.org>
 <504A32800200007800099E40@nat28.tlf.novell.com>
 <504A172B.5020005@canonical.com>
In-Reply-To: <504A172B.5020005@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.12 at 17:47, Stefan Bader <stefan.bader@canonical.com> wrote:
> On 07.09.2012 17:44, Jan Beulich wrote:
>> All of this still doesn't provide evidence that a plain upstream
>> kernel is actually having any problems in the first place. Further,
>> if you say EC2 has a crippled hypervisor patch - is that patch
>> available for looking at somewhere?
> 
> It was not a hypervisor patch. It was one for the guest. This was the hack:

So then why do you want to patch the upstream kernel? It won't
make that hack go away, nor will it help any existing kernels.

Jan

