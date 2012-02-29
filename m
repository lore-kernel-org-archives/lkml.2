Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2B2MTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:19:32 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38616 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2B2MTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:19:31 -0500
Date: Wed, 29 Feb 2012 13:19:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229121914.GD21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com>
 <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E145E.4040901@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 09:04:46AM -0300, Mauro Carvalho Chehab wrote:
> Not all information is packed in the record. The record packs only what it
> is inside the MCE registers. However, for certain errors, it is needed to
> parse other hardware registers to decode the error (for example, on Sandy
> Bridge, the MCE registers don't contain the affected dimms).

If SB is not using MCA to report the error, it should use either a
generic TP like the trace_hw_error() example I gave last week, or rather
a TP which matches the hw registers of the reporting hardware scheme.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
