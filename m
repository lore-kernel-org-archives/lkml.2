Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1DSRij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:38:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43560 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1DSRii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:38:38 -0400
Date: Tue, 19 Apr 2011 18:38:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] drm: Add a driver for kvm emulated Cirrus
Message-ID: <20110419173830.GA22955@srcf.ucam.org>
References: <1303157094-11425-1-git-send-email-mjg@redhat.com>
 <20110418220306.7799d850@lxorguk.ukuu.org.uk>
 <20110418212013.GA1778@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418212013.GA1778@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:20:13PM +0100, Matthew Garrett wrote:
> On Mon, Apr 18, 2011 at 10:03:06PM +0100, Alan Cox wrote:
> > So has this been benchmarked - intuitively I'd agree and expect that a
> > shadowfb driver ought to give best performance.
> 
> No, but it's noticably nicer to use under virt-manager. I'll try to come 
> up with some numbers.

x11perf shows it winning on every benchmark, with results ranging from 
10% to >20000% higher.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
