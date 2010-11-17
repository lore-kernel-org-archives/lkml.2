Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657Ab0KQJ1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:27:04 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38369 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804Ab0KQJ1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RHlwbgqeh9OH9GFLE/6gI4u+ZoytAAXfmb0Muj6sjoqY1aXG15mCsnghTAoT+sRCxV
         94o3c+pIQTZznnN4RjmXxyrB4qR8EbQtM0HG3aP7WD6O/q6UJu0CHHxhgnJ0Uj1/KJlg
         aKsXdA6OzWZdqAD5ZOQ4Qp/nUQLC354Db3ibs=
MIME-Version: 1.0
In-Reply-To: <20101117020759.016741414@intel.com>
References: <20101117020759.016741414@intel.com>
Date: Wed, 17 Nov 2010 01:26:59 -0800
X-Google-Sender-Auth: pr7Tq-X7I1TJkcSgOqELCSdt0yo
Message-ID: <AANLkTinp4A8U61rgODAKyQpauhgTbv4p55utaoVEQR0Q@mail.gmail.com>
Subject: Re: [0/8,v3] NUMA Hotplug Emulator - Introduction & Feedbacks
From: Yinghai Lu <yinghai@kernel.org>
To: shaohui.zheng@intel.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:07 PM,  <shaohui.zheng@intel.com> wrote:
>
> * WHAT IS HOTPLUG EMULATOR
>
> NUMA hotplug emulator is collectively named for the hotplug emulation
> it is able to emulate NUMA Node Hotplug thru a pure software way. It
> intends to help people easily debug and test node/cpu/memory hotplug
> related stuff on a none-numa-hotplug-support machine, even an UMA machine.
>
> The emulator provides mechanism to emulate the process of physcial cpu/mem
> hotadd, it provides possibility to debug CPU and memory hotplug on the machines
> without NUMA support for kenrel developers. It offers an interface for cpu
> and memory hotplug test purpose.
>
> * WHY DO WE USE HOTPLUG EMULATOR
>
> We are focusing on the hotplug emualation for a few months. The emualor helps
>  team to reproduce all the major hotplug bugs. It plays an important role to
> the hotplug code quality assuirance. Because of the hotplug emulator, we already
> move most of the debug working to virtual evironment.

You should extend kvm to make it support NUMA hotplug guest.
instead of messing up linux numa code.

Thanks

Yinghai
