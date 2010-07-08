Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab0GHVbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:31:51 -0400
Received: from 206-248-169-175.dsl.ncf.ca ([206.248.169.175]:34021 "HELO
	charlieb.ott.istop.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755156Ab0GHVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:31:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 17:31:50 EDT
Date: Thu, 8 Jul 2010 17:24:47 -0400 (EDT)
From: Charlie Brady <charlieb@budge.apana.org.au>
X-X-Sender: charlieb@e-smith.charlieb.ott.istop.com
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
cc: Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: RE: nic enumeration
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
Message-ID: <Pine.LNX.4.64.1007081718430.1581@e-smith.charlieb.ott.istop.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
 <20100708012120.GB11419@auslistsprd01.us.dell.com>
 <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jul 2010, Loke, Chetan wrote:

> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Matt Domsch
> > Sent: July 07, 2010 9:21 PM
> > 
> > http://lwn.net/Articles/356900/
> > 
> > And on a system where you can use udev rules, the
> > 70-persistent-net.rules file can be used to make them constant, by
> > using the MAC address to force the names to be what you want.
> 
> Ok, but can we achieve the renaming w/o a reboot? 

Yes, you can rename interfaces using the 'ip' command.

ip link set oldname name newname
