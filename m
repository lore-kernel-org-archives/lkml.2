Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0EXUeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:34:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37502 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab0EXUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VIIxifab7UsWXv/rNDUN3E0T0tJ3RT0g1/yKijQnfxr4lba/fCDHsmINk2f2WNuHDP
         1RxebZHaHxeswuqISOpH+fX56dDtA1vpoRKRqlDZBc4J/aeiG1+jlpx0BEIUUOAVSXu7
         +UT7M7XTrUrykdRPvi2r8qEntppPIAz+lng2Y=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: linux-next: build failure after merge of the kgdb tree
Date: Mon, 24 May 2010 13:34:03 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au> <20100524181735.GC6033@core.coreip.homeip.net> <4BFADBC1.9000802@windriver.com>
In-Reply-To: <4BFADBC1.9000802@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241334.04277.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 May 2010 01:04:17 pm Jason Wessel wrote:
> On 05/24/2010 01:17 PM, Dmitry Torokhov wrote:
> > Do we really need to force SysRq on or off? Maybe we should export
> > __handle_sysrq() instead?
> 
> It seems cleanest to export __handle_sysrq() if that is ok?

Yes, I think this is the best option. Please feel free to merge through
your tree.

Thanks.

-- 
Dmitry
