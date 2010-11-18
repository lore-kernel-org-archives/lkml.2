Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab0KRR7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:59:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0KRR7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:59:30 -0500
Date: Thu, 18 Nov 2010 09:58:56 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118175856.GB4931@suse.de>
References: <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
 <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
 <4CE5657D.8060105@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE5657D.8060105@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:42:21AM -0600, Timur Tabi wrote:
> > And getting rid of the redundant chardev driver would be a
> > simplification...
> 
> I agree there, but so far people have been telling me, "just do this!" without
> actually telling me how to do "this".

We can't do your work for you :)
