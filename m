Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1FHB7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:59:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1FHB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:59:18 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=ScYqa51SstsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=TjxrF1JDVoqQuucthHIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v4 04/13] seccomp_filter: add process state reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, jmorris@namei.org
In-Reply-To: <BANLkTikSFUqtvw8VZa2oXWOZL3tUnt+UEg@mail.gmail.com>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	 <1307133252-23259-4-git-send-email-wad@chromium.org>
	 <20110607235613.GA21645@linux.vnet.ibm.com>
	 <BANLkTikSFUqtvw8VZa2oXWOZL3tUnt+UEg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 21:59:15 -0400
Message-ID: <1307498355.9218.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 20:05 -0500, Will Drewry wrote:
> I opted for the simplest
> approach for now in hopes I wouldn't do it wrong yet-again.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

;)

-- Steve


