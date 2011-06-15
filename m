Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1FOSng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:43:36 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38154 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752013Ab1FOSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:43:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RU7vN/MNfu3wot0kq+ZQBbim6hRgB27C8+nISX0H9nb15baoDGEItKKSyZhWqgkrbMsIUvEft8ZFWQ/K1jygBv92aGEWj1bpEK021pQNLnUSdet0jOAboaOJaZlE7Sc2;
Date: Wed, 15 Jun 2011 11:43:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Zhavnerchik" <alex.vizor@gmail.com>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
Message-ID: <20110615114329.7429ff43@jbarnes-desktop>
In-Reply-To: <JL7O0m0yLjL.A.vCD.COS9NB@chimera>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
	<JL7O0m0yLjL.A.vCD.COS9NB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 22:30:52 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
> Subject		: Artifacts with 3.0-rc1 on SandyBridge
> Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
> Date		: 2011-06-01 13:55 (12 days old)

Can you try bisecting this one?

-- 
Jesse Barnes, Intel Open Source Technology Center
