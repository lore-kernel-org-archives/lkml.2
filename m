Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0CVAT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0CVAT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:19:57 -0400
Date: Sun, 21 Mar 2010 18:19:20 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Regression in i915 on 2.6.34-rc1
Message-ID: <20100321181920.1330d55a@redhat.com>
In-Reply-To: <201003170926.59931.bjorn.helgaas@hp.com>
References: <20100311003358.58194366@redhat.com>
	<1268535744.28444.16.camel@dc7800.home>
	<201003151151.01891.bjorn.helgaas@hp.com>
	<201003170926.59931.bjorn.helgaas@hp.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 08:26:59 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> > > > http://bugzilla.kernel.org/show_bug.cgi?id=15533
> 
> Any luck testing the patch from the bugzilla?  I'd really like to get
> this figured out so we can get the fix in the next -rc and move on
> to the next _CRS issue :-)

I was on vacation, sorry. Got to it today. In short, the test patch fails.
Please see the dmesg with ACPI debugging in bugzilla as requested.

-- Pete
