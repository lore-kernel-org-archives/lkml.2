Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1GAXve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:51:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1GAXvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAOM-RdN3cweRQnNxCaCGuyj2GMojix15XG5MVj8pxj7FHX79hg@mail.gmail.com>
References: <1308797024.23204.95.camel@debian>
	<BANLkTimEcPmH_XgLy5aEW+znwJyVZzfoCg@mail.gmail.com>
	<CAOM-RdN3cweRQnNxCaCGuyj2GMojix15XG5MVj8pxj7FHX79hg@mail.gmail.com>
Date: Sat, 2 Jul 2011 07:51:32 +0800
Message-ID: <CACVXFVO6RNjEeb=yBF9ND3=dYg55-H3mfySh6t1JC_jGPmTFAw@mail.gmail.com>
Subject: Re: power increase issue on light load
From: Ming Lei <tom.leiming@gmail.com>
To: Nikhil Rao <ncrao@google.com>
Cc: "Alex,Shi" <alex.shi@intel.com>, peterz@infradead.org, mingo@elte.hu,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 2, 2011 at 2:00 AM, Nikhil Rao <ncrao@google.com> wrote:
> Thanks for reporting this issue. Looks like the increased resolution
> has a negative impact on power savings balance. I'm looking into this
> issue based on Alex's data, but If you can give a trace or something
> that I can work with it will be really helpful.

No problem if I can do it, which traces are needed for you to figure out
the root cause?

thanks,
-- 
Ming Lei
