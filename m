Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2ENNZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:25:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2ENNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:25:44 -0400
Date: Mon, 14 May 2012 14:25:40 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120514132540.GB28957@srcf.ucam.org>
References: <20120501120145.21f65ae2@lwn.net>
 <20120501183149.GA28536@srcf.ucam.org>
 <20120501123923.01ac1138@lwn.net>
 <20120501185455.GA29060@srcf.ucam.org>
 <20120501192736.GA29770@srcf.ucam.org>
 <20120501172454.0e811379@lwn.net>
 <20120502215034.GA622@srcf.ucam.org>
 <20120502160437.5f355fa3@lwn.net>
 <20120502222724.GB2215@srcf.ucam.org>
 <20120510165144.57a96941@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510165144.57a96941@lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 04:51:44PM -0600, Jonathan Corbet wrote:

> Sorry it took me so long to figure that out, and thanks for the help.  Can
> you get the fixed rules into rawhide, or should I go bug somebody?

Doh. Wonderful, thanks - I'll get that pushed to Kay.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
