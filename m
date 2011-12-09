Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1LISH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:07:28 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45667 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab1LISHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:07:24 -0500
X-Sasl-enc: h3VVfQTVfja4uDWJM66HgvDOdu5koNacHIgnTTildQFv 1323454042
Date: Fri, 9 Dec 2011 10:07:08 -0800
From: Greg KH <greg@kroah.com>
To: Anand Kanaginhal <anand_dk@hotmail.com>
Cc: mjg59@srcf.ucam.org, bhelgaas@google.com,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
Message-ID: <20111209180708.GA10768@kroah.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
 <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
 <20111130154022.GA1411@srcf.ucam.org>
 <BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>
 <20111130182423.GA4831@srcf.ucam.org>
 <CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
 <BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>
 <20111209124524.GA3488@srcf.ucam.org>
 <BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 09:19:39AM -0800, Anand Kanaginhal wrote:
> 1. With the above setup, If I hotplug card c1 and/or c2, will my driver probe 
> get invoked. 

Stop right here.  Please get your pci hotplug controller driver working
first, for your platform.  That seems to be the problem.  After that,
the rest of your questions should just resolve themselves.

greg k-h
