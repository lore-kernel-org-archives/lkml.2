Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2F0NLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:11:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33041 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2F0NK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:10:59 -0400
Message-ID: <1340802641.10063.64.camel@twins>
Subject: Re: [PATCH 1/2] perf/x86: Use 0xff as pseudo code for fixed uncore
 event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 15:10:41 +0200
In-Reply-To: <CABPqkBRYcpxUX+j=roJKwmFMbdfoHf0APwusEEG6BS6cU_U+zQ@mail.gmail.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBRYcpxUX+j=roJKwmFMbdfoHf0APwusEEG6BS6cU_U+zQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:06 +0200, Stephane Eranian wrote:
> I would still do: event=0xff,umask=0x00
> to reinforce the fact that first fixed counter is index 0x00. 

Ok, fixed up the patch..
