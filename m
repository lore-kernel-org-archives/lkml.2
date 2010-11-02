Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0KBM6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:58:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35340 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0KBM61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=IHTr4X9CB41bMaGaI0pRqI4TTDPS0sf2fPzy90wIST3k6LOgwrkLUEcFkjdwQw/Ydy
         YY8vEgyZHMdORbABRF8DQN9FDuOoi6bNYN+s+85YAXOiTlgTrg6ZLITEvKa6kG7uadKj
         M1j5ihorWuHU4VJxWJxtfbWXU/rxGbn9VZ/Mg=
From: Ben Gamari <bgamari.foss@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 02 Nov 2010 08:58:19 -0400
Message-ID: <87oca7evbo.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010 20:33:10 -0700 (PDT), David Rientjes <rientjes@google.com> wrote:
> And they can't use an init script to tune /proc/sys/vm/swappiness 
> because...?

Packaging concerns, as I mentioned before,

On Mon, Nov 01, 2010 at 08:52:30AM -0400, Ben Gamari wrote:
> Ubuntu ships different kernels for desktop and server usage. From a
> packaging standpoint it would be much nicer to have this set in the
> kernel configuration. If we were to throw the setting /etc/sysctl.conf
> the kernel would depend upon the package containing sysctl(8)
> (procps). We'd rather avoid this and keep the default kernel
> configuration in one place.

In short, being able to specify this default in .config is just far
simpler from a packaging standpoint than the alternatives.

- Ben

