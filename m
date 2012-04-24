Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2DXIEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:04:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2DXIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:04:23 -0400
Date: Tue, 24 Apr 2012 10:04:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, fenghua.yu@intel.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
Message-ID: <20120424080420.GA27374@one.firstfloor.org>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6> <20120416022139.9303.56284.stgit@localhost6.localdomain6> <m2ipgqoh90.fsf@firstfloor.org> <20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> native_cpu_up avoids to wake up cpu with boot_cpu_physical_apicid, but

Ok so that check needs to go then. I wonder why it is there.

> the boot_cpu_physical_apicid would be just a boot cpu now, which could
> be non-BSP on the 2nd kernel; equal to crashing cpu on the 1st
> kernel. It would need to check explicitly whether a given cpu is BSP
> or not and this would be better fix here. This is suggested by Eric.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
