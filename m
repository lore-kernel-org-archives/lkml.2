Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0KAOBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:01:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab0KAOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:00:58 -0400
Date: Mon, 1 Nov 2010 15:00:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [x86, next] Add mce_sys_info interface for debug.
Message-ID: <20101101140057.GD25817@basil.fritz.box>
References: <4CCA50AF.1030302@np.css.fujitsu.com>
 <20101029081003.GB11149@basil.fritz.box>
 <4CCE04C7.3050803@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCE04C7.3050803@np.css.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 09:07:35AM +0900, Jin Dongming wrote:
> Hi, Andi
> 
> Thanks for your review.
> I will cancel this patch.
> 
> But I suggested there is such kind of tool for mce test.
> It really costs too much time to confirm them one by one.

I would suggest to write a shell script and put it to download
somewhere. We could add a reference to it to the kernel documentation.

-Andi
