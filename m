Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0KVQBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:01:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54005 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0KVQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:01:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i1z3ypnu3meu4L5VYtja8zJU+7U1EQDasbPgXKTZeUZsCYMmksfiz0iUps7IajdYK7
         D4dGiDJghsBFf+InvncOpjcyKP5XdYhWDlpKuyu3N9FIVBJoeQGd4t02aeuzQ6+1uuzz
         tFAMU+/7YFFpOMJkwQAaxtt8ZHT9jjGi2PhGQ=
Date: Tue, 23 Nov 2010 00:04:12 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8,v3] NUMA Hotplug Emulator: documentation
Message-ID: <20101122160412.GE4137@hack>
References: <20101117020759.016741414@intel.com> <20101117021000.985643862@intel.com> <20101121150344.GK9099@hack> <20101121233351.GA7626@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101121233351.GA7626@shaohui>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 07:33:51AM +0800, Shaohui Zheng wrote:
>On Sun, Nov 21, 2010 at 11:03:45PM +0800, Américo Wang wrote:
>> 
>> >From your documentation above, it looks like you are trying
>> to move one CPU between nodes?
>Yes, you are correct. With cpu probe/release interface, you can hot-remove a
>CPU from a node, and hot-add it to another node.


Can I also move the CPU to another node _after_ it is hot-added?
Or I have to hot-remove it first and then hot-add it again?

>> 
>> >+	cpu_hpe=on/off
>> >+		Enable/disable cpu hotplug emulation with software method. when cpu_hpe=on,
>> >+		sysfs provides probe/release interface to hot add/remove cpu dynamically.
>> >+		this option is disabled in default.
>> >+			
>> 
>> Why not just a CONFIG? IOW, why do we need to make another boot
>> parameter for this?
>Only the developer or QA will use the emulator, we did not want to change the
>default action for common user who does not care the hotplug emulator, so we
>use a kernel parameter as a switch. The common user is not aware the existence
>of the emulator.
>

I think it is also useful to other Linux users, e.g. after I
boot with "maxcpus=1", I can still bring the rest 3 CPU's
back without reboot.

Thanks.

-- 
Live like a child, think like the god.
 
