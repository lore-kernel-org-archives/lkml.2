Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0JDG7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 02:59:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0JDG7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 02:59:45 -0400
Date: Mon, 4 Oct 2010 08:59:35 +0200
From: Heinz Diehl <htd@fritha.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #19632] 2.6.36-rc6: modprobe Not tainted warning
Message-ID: <20101004065935.GD7237@fritha.org>
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
 <TPWomcQcd8K.A.sHB.DDPqMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TPWomcQcd8K.A.sHB.DDPqMB@chimera>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V02:K0:fDR1HuxEAtBsxzuq8KX6maOCtGZ2xxk+E7blnzwKQkr
 tpiYzWjhX6SzQnOHjjo7kc0WpQaj6TeLPb919YS6b4d480c38s
 rH9EI9FNA7q5y8T40XAg1VCM+xFcZs+SlhGPur561HIkU9nnRN
 QH8PbQOaMVIrbqUNJykXB0QNajCuuucq6Rnk3OKQmtVx8V9FON
 Kd99EjSBd1tgYq0pi7jYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.2010, Rafael J. Wysocki wrote: 

> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19632
> Subject		: 2.6.36-rc6: modprobe Not tainted warning
> Submitter	: Heinz Diehl <htd@fritha.org>
> Date		: 2010-09-30 18:25 (4 days old)
> Message-ID	: <20100930182516.GA15089@fritha.org>
> References	: http://marc.info/?l=linux-kernel&m=128587114004680&w=2

This should still be listed, yes. It is also present in the latest rc from
git repository.

