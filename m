Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0KUOmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:42:04 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65331 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0KUOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:42:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPdAFuOe5YljvXXzWDFFa1DbXUnPgTZo6nL7MTSucWKBUQEgs0NoHL/Uc7L0xomBmk
         PwExvI/pa/C6ZVYQs5Lklaum90wMqrZz/i/5WcsAIcVnUgbS7+92OpkHXWZHQDDtxC+H
         Pnhy5rpRTOb9gG7HDKVdnblfQqdk3Cg6w3a2M=
Date: Sun, 21 Nov 2010 22:45:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: shaohui.zheng@intel.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <Yinghai.Lu@Sun.COM>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [5/8,v3] NUMA Hotplug Emulator: support cpu probe/release in
	x86
Message-ID: <20101121144511.GJ9099@hack>
References: <20101117020759.016741414@intel.com> <20101117021000.776651300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117021000.776651300@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:08:04AM +0800, shaohui.zheng@intel.com wrote:
>From: Shaohui Zheng <shaohui.zheng@intel.com>
>
>Add cpu interface probe/release under sysfs for x86. User can use this
>interface to emulate the cpu hot-add process, it is for cpu hotplug 
>test purpose. Add a kernel option CONFIG_ARCH_CPU_PROBE_RELEASE for this
>feature.
>
>This interface provides a mechanism to emulate cpu hotplug with software
> methods, it becomes possible to do cpu hotplug automation and stress
>testing.
>

Huh? We already have CPU online/offline...

Can you describe more about the difference?

Thanks.
