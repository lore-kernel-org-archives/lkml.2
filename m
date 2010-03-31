Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0CaCm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:42:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0CaCmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:42:18 -0400
Date: Wed, 31 Mar 2010 04:42:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping 3
Message-ID: <20100331024213.GV20695@one.firstfloor.org>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:03:02AM +0200, Jiri Kosina wrote:
> Hi,
> 
> booting 32bit guest on 32bit host on AMD system gives me the following 
> warning when KVM is instructed to boot as SMP:

I guess these warnings could be just disabled. With nearly everyone
using multi-core these days they are kind of obsolete anyways.

-Andi


