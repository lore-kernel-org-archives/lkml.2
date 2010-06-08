Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab0FHWUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:20:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49121 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932211Ab0FHWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:20:49 -0400
Date: Tue, 8 Jun 2010 23:29:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, <alan@linux.intel.com>,
       <jacob.jun.pan@linux.intel.com>, <arjan@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>, <mingo@elte.hu>,
       <feng.tang@intel.com>, <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100608232916.2c98703a@lxorguk.ukuu.org.uk>
In-Reply-To: <m18w6p5fwk.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
	<20100608201258.6c813085@linux.intel.com>
	<SNT125-W593A227B1D8643303EE24DC3D60@phx.gbl>
	<m18w6p5fwk.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Until then I guess we get things like Moorestown which are effectively
> a reinvention of ISA based systems, with different firmware, and

I'm not quite sure where you get that idea from ?

