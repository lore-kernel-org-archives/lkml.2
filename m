Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2JRT7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:59:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57756 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753033Ab2JRT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:59:47 -0400
Message-ID: <1350590386.5652.7.camel@joe-AO722>
Subject: Re: [PATCH] dynamic_debug: Remove unnecessary __used
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 12:59:46 -0700
In-Reply-To: <20121018194027.GA1246@kroah.com>
References: <1350587223.5652.4.camel@joe-AO722>
	 <20121018194027.GA1246@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 12:40 -0700, Greg KH wrote:
> On Thu, Oct 18, 2012 at 12:07:03PM -0700, Joe Perches wrote:
> > The __used attribute prevents gcc from eliminating
> > unnecessary, otherwise optimized away, metadata for
> > debugging logging messages.
> > 
> > Remove the __used attribute.
> 
> Very cool.  Any idea how much space this saves?

Dunno, it's been a while since I did an allyesconfig on my
netbook, my recollection is that was a few hundred kb.

https://lkml.org/lkml/2012/5/17/340


