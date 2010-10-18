Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab0JRWfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:35:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab0JRWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:35:42 -0400
Date: Mon, 18 Oct 2010 15:33:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Message-Id: <20101018153350.18b68c50.akpm@linux-foundation.org>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 18:24:11 -0400
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> Hi,
> 
> Final messages from reboot, halt and poweroff aren't output to disk because klogd/syslogd 
> has been killed and root file system has been turned read-only.
> 
> Final messages from emergency_restart aren't output to disk as well because system may
> reboot before klogd/syslogd outputs messages to disk.
> 
> Therefore, it is better to put kmsg_dumper in reboot/halt/poweroff/emergency_restart path.
> Any comments/advices are welcome.
> 

I don't get it.

What actual problem are we solving here?  Why is the current code
inadequate?  It would help to demonstrate some use-case and to explain
how the situation improved with this patch.

