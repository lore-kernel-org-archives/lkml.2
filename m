Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab1ELSW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:22:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32775 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818Ab1ELSW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:22:57 -0400
Date: Thu, 12 May 2011 11:22:29 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource
 allocation.
Message-ID: <20110512182229.GQ8195@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20110506081243.GF16782@ram-laptop>
 <4DC4586C.6020308@kernel.org>
 <20110507015240.GN16782@ram-laptop>
 <4DC4B059.3030502@kernel.org>
 <4DC64C58.70203@kernel.org>
 <20110509142014.617e3100@jbarnes-desktop>
 <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>
 <4DC9E415.5010402@kernel.org>
 <20110512180638.GA5012@ram-laptop>
 <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:14:07AM -0700, Linus Torvalds wrote:
> On Thu, May 12, 2011 at 11:06 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> >
> > I like this approach than the earlier approach because it
> > closes the subtle bug _introduced_ by my earlier patch,
> >        commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
> >
> > However i think the implementation can be made cleaner. Comments below..
> 
> Ack on all of that. Do we have confirmation that the patch works, though?

In theory it should work. But I have not tested it yet. I will work with Yinghai and
have a cleaned-up/working/tested patch your way soon.

RP
