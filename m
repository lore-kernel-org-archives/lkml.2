Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1A1Qte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:49:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1A1Qtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:49:33 -0500
Date: Fri, 28 Jan 2011 17:49:31 +0100
From: Matthias Hopf <mhopf@suse.de>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: Re: [REGRESSION] S3 suspend on SandyBridge freezes due to
 on_each_cpu() change (bd924e8)
Message-ID: <20110128164931.GA25196@suse.de>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Matthieu CASTET <castet.matthieu@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
	Oliver Neukum <oneukum@suse.de>
References: <20110126160231.GA29021@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126160231.GA29021@suse.de>
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 11 17:02:31 +0100, Matthias Hopf wrote:
> While bisecting a dri S3 issue I stumbled in 2.6.38-rc1 over a
> regression because of NX protection (5bd5a4, currently being discussed),
> and with a patch fixing this issue I stumbled again in 2.6.38-rc2
> because of commit bd924e8:

The patch in https://bugzilla.kernel.org/show_bug.cgi?id=27472#c9 fixes
both regressions.

Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de
