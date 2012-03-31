Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2CaScy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:32:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42603 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2CaScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:32:51 -0400
Date: Sat, 31 Mar 2012 19:32:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Ken Moffat <zarniwhoop@ntlworld.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is
 disabled
Message-ID: <20120331183246.GA14437@srcf.ucam.org>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
 <20120331033306.GA2475@burratino>
 <CA+55aFy2WdyeBc0j77UAjisThrm2ZDbC7O1O05kiOeBeiP1KZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy2WdyeBc0j77UAjisThrm2ZDbC7O1O05kiOeBeiP1KZQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:20:41AM -0700, Linus Torvalds wrote:
> On Fri, Mar 30, 2012 at 8:33 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> >
> > You might enjoy the following patch:
> >
> >  http://thread.gmane.org/gmane.linux.kernel.pci/14503
> 
> Yes, good. I guess I should just take it and not wait for Bjorn, since
> we really need this for stable too. Matthew?

Works for me.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
