Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2KNCDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:03:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40708 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab2KNCDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:03:10 -0500
Message-ID: <50A2FBC0.6050409@zytor.com>
Date: Tue, 13 Nov 2012 18:02:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel> <1352858437.18025.47.camel@gandalf.local.home>
In-Reply-To: <1352858437.18025.47.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:00 PM, Steven Rostedt wrote:
> 
> Using printk to export something like this is IMO a nasty hack.
> 
> Can't we create a /sys or /proc file to export the same thing?
> 

Maybe we need a /proc/pid/kvm/* directory?

	-hpa


