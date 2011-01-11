Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1AKO1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:27:44 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:56760 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1AKO1m convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 11 Jan 2011 09:27:42 -0500
Message-Id: <4D2C76E9020000780002BB73@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 11 Jan 2011 14:27:37 +0000
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
 <4D2C72FA020000780002BB58@vpn.id2.novell.com>
 <1294755483.3831.5872.camel@zakaz.uk.xensource.com>
In-Reply-To: <1294755483.3831.5872.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.01.11 at 15:18, Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
>> >> I'm mainly asking because if it really addresses some problem,
>> >> then unmodified_drivers/linux-2.6/platform-pci/platform-pci.c
>> >> in -unstable should probably get updated too.
>> > 
>> > Assuming the pci_* interfaces exist back as far as we care about for
>> > those drivers then I don't see why not to apply it.
>> 
>> I checked back to .5, where they exist; the question is - how far
>> back do we care?
> 
> You mean 2.6.5? That's old enough to be the cut off IMHO.
> 
> I'm not sure how much actual use these drivers get these days though.

We're building ours from that code.

Are you going to submit this for -unstable then too, or are you
expecting me to do so?

Jan

