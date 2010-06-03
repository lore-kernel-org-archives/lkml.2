Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0FCRKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:10:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33620 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0FCRKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:10:43 -0400
Date: Thu, 3 Jun 2010 10:08:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to stop kernel rebooting during startup?
Message-Id: <20100603100829.4f2c78f3.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimaYtD9qzPYmABVg3clxE6KYeo5bgI8Qp_IBr14@mail.gmail.com>
References: <kqld06dbv2ektmqfadr8l3dqtmm6hler2c@4ax.com>
	<AANLkTimaYtD9qzPYmABVg3clxE6KYeo5bgI8Qp_IBr14@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C07E1F2.011D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 18:35:45 -0400 Bob Copeland wrote:

> On Wed, Jun 2, 2010 at 6:20 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
> > which worked fine on slackware64-13.0, has this behaviour on slack-
> > ware64-13.1.  Because I cannot read the screen before reboot, no idea
> > where to look next, or what is actually happening.
> 
> Maybe try CONFIG_BOOT_PRINTK_DELAY to see the message?

That's one option.

Can you alter the kernel command line (boot options)?
like add:  initcall_debug debug ignore_loglevel pause_on_oops=30


Sounds like it would also be good to have something like:
	reboot=hang|spin
(TBD)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
