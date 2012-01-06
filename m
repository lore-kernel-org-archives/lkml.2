Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2AFTNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:13:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055Ab2AFTNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:13:45 -0500
Date: Fri, 6 Jan 2012 12:57:58 -0500
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20120106175757.GA16807@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20111230193704.GA2874@redhat.com>
 <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop>
 <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
 <20120103180020.GA15014@redhat.com>
 <CAErSpo6S19rznjbkos3LPk8K9GK=kFUr9+OqRfeZ72TiJpj35Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6S19rznjbkos3LPk8K9GK=kFUr9+OqRfeZ72TiJpj35Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 10:32:14AM -0700, Bjorn Helgaas wrote:

 > > There's at least one more dell (Seems that entire 'studio' product line
 > > is affected) that I'm waiting on DMI data from.
 > > Also a thinkpad that I have a patch pending for.
 > 
 > I think we should drop the Dell 1536 blacklist entry from this patch
 > (adding set_nouse_crs() itself is fine and may be needed for other
 > machines).
 > 
 > The patches here: https://lkml.org/lkml/2012/1/5/402 should cover the
 > Dell 1536 issue as well as the Dell 1546 and any others with the same
 > BIOS defect.

Sounds good to me.

	Dave

