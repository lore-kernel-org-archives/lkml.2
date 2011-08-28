Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1H1TwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:52:11 -0400
Received: from void.printf.net ([89.145.121.20]:58937 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab1H1TwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:52:02 -0400
From: Chris Ball <cjb@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Andrei Warkentin" <andreiw@motorola.com>,
        "Peter Vollmer" <vollmerpeter@googlemail.com>
Subject: Re: [Bug #38922] Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
	<gUVi6eNP8RE.A.uJH.tfpWOB@chimera>
Date: Sun, 28 Aug 2011 15:51:45 -0400
In-Reply-To: <gUVi6eNP8RE.A.uJH.tfpWOB@chimera> (Rafael J. Wysocki's message
	of "Sun, 28 Aug 2011 21:01:11 +0200 (CEST)")
Message-ID: <m2fwklxqjy.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sun, Aug 28 2011, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38922
> Subject : Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition
> writing and io errors on insert
> Submitter	: Peter Vollmer <vollmerpeter@googlemail.com>
> Date		: 2011-07-07 17:33 (53 days old)
> First-Bad-Commit:
> http://git.kernel.org/linus/a3c7778f8153b9e4eceea6738973280b9e63c618

Yes, still present.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
