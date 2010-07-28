Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0G1HrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:47:10 -0400
Received: from mxs.selfmail.ru ([77.221.143.26]:55762 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753238Ab0G1HrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:47:06 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 03:47:06 EDT
X-ACL-SPF: 
Subject: Re: [Xen-devel] [PATCH] GSoC 2010 - Memory hotplug support for Xen
 guests - fully working version
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Daniel Kiper <dkiper@net-space.pl>
Cc: jeremy@goop.org, gregkh@suse.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100727004113.GA3714@router-fw-old.local.net-space.pl>
References: <20100727004113.GA3714@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Wed, 28 Jul 2010 11:36:29 +0400
Message-ID: <1280302589.6376.1.camel@vase.work>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Втр, 27/07/2010 в 02:41 +0200, Daniel Kiper пишет:
> Hi,
> 
> Currently there is fully working version.
> It has been tested on Xen Ver. 4.0.0 in PV
> guest i386/x86_64 with Linux kernel Ver. 2.6.32.16
> and Ver. 2.6.34.1. This patch cleanly applys
> to Ver. 2.6.34.1 (also as attachment because
> I received some reports that my patches are
> mangled). All found bugs have been removed
> (Sorry however I am sure that some hidden
> still exists :-((().


Work's fine with opensuse 11.3 (dom0 and domU)


-- 
Vasiliy G Tolstov <v.tolstov@selfip.ru>
Selfip.Ru

