Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab1AKOK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:10:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45043 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab1AKOK4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 11 Jan 2011 09:10:56 -0500
Message-Id: <4D2C72FA020000780002BB58@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 11 Jan 2011 14:10:50 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <Ian.Campbell@eu.citrix.com>
Cc: "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: use PCI interfaces to request IO
	 and MEM resources on platform device.
References: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
 <4D2C5FA5020000780002BB21@vpn.id2.novell.com>
 <1294750884.3831.5866.camel@zakaz.uk.xensource.com>
In-Reply-To: <1294750884.3831.5866.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.01.11 at 14:01, Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> The old way was correct circa 2.6.37-rc5 but broken in 2.6.37 final,
> there were a bunch of (reverts of) PCI resource changes in that window,
> If I had to make a guess I'd say it was something in there which did it.

Was it perhaps broken somewhere between -rc5 and -final, but
not in -final itself?

>> I'm mainly asking because if it really addresses some problem,
>> then unmodified_drivers/linux-2.6/platform-pci/platform-pci.c
>> in -unstable should probably get updated too.
> 
> Assuming the pci_* interfaces exist back as far as we care about for
> those drivers then I don't see why not to apply it.

I checked back to .5, where they exist; the question is - how far
back do we care?

Jan

