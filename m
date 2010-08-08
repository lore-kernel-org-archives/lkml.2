Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0HHMDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:03:12 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:34706 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab0HHMDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:03:06 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Alexander Graf <agraf@suse.de>
Cc: Dieter Ries <mail@dieterries.net>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
	<1258373983-8693-24-git-send-email-avi@redhat.com>
	<4BA1504A.3090801@dieterries.net>
	<808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
	<20100317224002.GA5156@Localhorst.asterix.local>
	<59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
	<20100318071131.GC24062@Localhorst.asterix.local>
	<4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de>
Date: Sun, 08 Aug 2010 12:02:57 +0000
In-Reply-To: <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de> (Alexander Graf's
	message of "Thu, 18 Mar 2010 08:17:01 +0100")
Message-ID: <87ocddz4zy.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Since the above patch went in
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=10474ae8
I have exactly the same problem as Dieter.

>>> If that's the case I'd say you have a broken BIOS or bootloader.
>> 
>> You are right, it seems to be always cpu0. I'll check my BIOS and flash
>> a newer version if available.
>
> Please do. If that doesn't help ping me again. I'll write up a quirk patch then.
>

My h/w is a bit different (cpu: 9850 B3, mb: GA-MA790FX-DQ6 bios F7b),
but I cannot use latest available BIOS (F7d) as it breaks my SAS controller.

So I guess I need the quirk patch.
