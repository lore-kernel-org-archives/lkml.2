Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab1CXVrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:47:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:15888 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1CXVrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,239,1299484800"; 
   d="scan'208";a="901484352"
From: Andi Kleen <andi@firstfloor.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Burt Triplett <burt@pbjtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
References: <4D65EE74.1050709@pbjtriplett.org>
	<20110312023001.GB27550@khazad-dum.debian.net>
	<4D87E2CD.6020306@pbjtriplett.org>
	<20110324001451.GA7950@khazad-dum.debian.net>
Date: Thu, 24 Mar 2011 14:46:21 -0700
In-Reply-To: <20110324001451.GA7950@khazad-dum.debian.net> (Henrique de Moraes
	Holschuh's message of "Wed, 23 Mar 2011 21:14:51 -0300")
Message-ID: <m2ipv8kx8y.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:
>
> Very well, I will send patches to fix that behaviour, as well as some
> other stuff I noticed that was not updated to match the recommended
> actions documented by the SDM and some Intel application notes.

I don't think you can easily -- there's no kernel interface
to distingush the "explicit user action" case from automatic loading.

This all would need a new kernel interface.

I suppose all the test labs have learned by now how to disable
automatic updates ...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
