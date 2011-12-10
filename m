Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1LJQIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 11:08:10 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:50945 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1LJQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 11:08:07 -0500
Date: Sat, 10 Dec 2011 17:08:03 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 0/4] V2, Move stuff out of xenfs
Message-ID: <20111210160803.GA15557@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	David Vrabel <david.vrabel@citrix.com>,
	Ian Campbell <Ian.Campbell@citrix.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
 <1323333259.2969.56.camel@zakaz.uk.xensource.com>
 <20111208092855.GB22678@wavehammer.waldi.eu.org>
 <4EE09B42.4090801@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE09B42.4090801@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 11:10:58AM +0000, David Vrabel wrote:
> On 08/12/11 09:28, Bastian Blank wrote:
> > On Thu, Dec 08, 2011 at 08:34:19AM +0000, Ian Campbell wrote:
> >> How are we doing on the corresponding toolstack changes?
> > I have at least parts of it somewhere on my workstation. I'll polish and
> > submit them also.
> I assume the toolstack will fall back to xenfs if the devices don't exist?

This was the plan.

Bastian

-- 
	"Get back to your stations!"
	"We're beaming down to the planet, sir."
		-- Kirk and Mr. Leslie, "This Side of Paradise",
		   stardate 3417.3
