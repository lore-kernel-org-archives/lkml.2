Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab0EDPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab0EDPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:23:16 -0400
Message-ID: <4BE03B93.1010005@redhat.com>
Date: Tue, 04 May 2010 11:21:55 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com> <20100427183428.GA15385@phenom.dumpdata.com> <4BD73134.1030308@redhat.com> <20100503191634.GA19699@phenom.dumpdata.com> <20100504150214.GA5667@phenom.dumpdata.com>
In-Reply-To: <20100504150214.GA5667@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Interestingly enough, I couldn't reproduce this on my Intel box, but on
> a AMD box with a very wacked TSC (cpu MHz         : 2795681.405) I can
> reproduce this.
>
>    

Huh ... that's odd.  I'll grab a dinar based system and see if I can 
reproduce it there.  It would be interesting to know what the 
differences are.

P.
