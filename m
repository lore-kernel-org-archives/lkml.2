Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2EVSfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:35:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63526 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2EVSfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:35:52 -0400
MIME-Version: 1.0
In-Reply-To: <jpglns$1uj$1@dough.gmane.org>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
	<4FBBB11D.7020904@web.de>
	<20120522155345.GC14339@google.com>
	<4FBBC461.4060008@web.de>
	<20120522170320.GD14339@google.com>
	<jpglns$1uj$1@dough.gmane.org>
Date: Tue, 22 May 2012 11:35:49 -0700
X-Google-Sender-Auth: F0DDqFG4UtCtpCxw0-NXjK2XV_A
Message-ID: <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com>
Subject: Re: Linux 3.4 released
From: Tejun Heo <tj@kernel.org>
To: =?ISO-8859-1?Q?J=F6rg=2DVolker_Peetz?= <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 22, 2012 at 11:26 AM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
> Also with this second patch I wasn't able to see any output beginning with "XXX
> delayed_work_timer_fn:". It should appear in the system log or on the text-console?

Hmmm... it should appear on the console but your printk setting might
be different. Can you please prepend KERN_CRIT before the printk
format string? So that it looks like printk(KERN_CRIT "XXX: ...").

Thanks.

-- 
tejun
