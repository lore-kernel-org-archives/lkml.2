Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2CMAq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976Ab2CMAqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:46:54 -0400
Date: Tue, 13 Mar 2012 01:46:42 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120313004642.GA19090@host2.jankratochvil.net>
References: <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E76CE.4030601@zytor.com>
 <20120312223144.GA9636@host2.jankratochvil.net>
 <4F5E91DE.80609@zytor.com>
 <20120313002725.GA17828@host2.jankratochvil.net>
 <4F5E956F.3070108@zytor.com>
 <20120313003639.GA18427@host2.jankratochvil.net>
 <4F5E97EA.6030001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E97EA.6030001@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 01:42:18 +0100, H. Peter Anvin wrote:
> There is no 100% reliable solution possible -- you have no guarantee of
> any kind that the library executable still exists.

I have guarantee that the library binary mapped in memory identified by
build-id can be found out there in the could.  There is no other guarantee.
And this guarantee fails with other solutions.

If you say that it is _additional_ info to build-id then yes, one can always
use build-id if everything else fails.  But then the non-build-id information
is redundant and it can just lead to wrong toolchain solutions - which has
already happened (Apport).


Regards,
Jan
