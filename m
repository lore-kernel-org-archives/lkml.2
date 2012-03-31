Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2CaDdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 23:33:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2CaDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 23:33:12 -0400
Date: Fri, 30 Mar 2012 22:33:06 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120331033306.GA2475@burratino>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331032356.GA6664@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

Ken Moffat wrote:

>                                                   Long story short -
> 3.2.9 was adequate, 3.3.0 crashes early in boot (before switching
> from the 80x25 console to kms).
[...]
>  I then reverted this commit from 3.3.0

You might enjoy the following patch:

 http://thread.gmane.org/gmane.linux.kernel.pci/14503

Hope that helps,
Jonathan
