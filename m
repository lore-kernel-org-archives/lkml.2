Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab1JFUEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab1JFUEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:04:43 -0400
Date: Thu, 6 Oct 2011 16:04:40 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006200440.GB25681@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <20111006195824.GA22033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006195824.GA22033@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:58:24PM -0700, Greg Kroah-Hartman wrote:

 > > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
 > > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
 > 
 > We could do that in a "generic" way by setting a "in-tree" flag type
 > thing for everything that is built from within the kernel build, and
 > then taint if that flag is not found.

what stops an out of tree module from setting that flag ?
I guess I need to see the implementation to understand this. 

	Dave 
