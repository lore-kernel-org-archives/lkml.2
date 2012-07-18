Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2GRIIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:08:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36850 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2GRIID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:08:03 -0400
Date: Wed, 18 Jul 2012 10:07:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tglx@linutronix.de, tony.luck@intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V2] x86: mce: Bugfixes, cleanups and a new CMCI poll version
Message-ID: <20120718080745.GA11790@aftab.osrc.amd.com>
References: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 03:59:29PM -0400, Chen Gong wrote:
> [PATCH 1/5] x86: mce: Disable preemption when calling raise_local()
> [PATCH 2/5] x86: mce: Serialize mce injection
> [PATCH 3/5] x86: mce: Split timer init
> [PATCH 4/5] x86: mce: Remove the frozen cases in the hotplug code
> [PATCH 5/5] x86: mce: Add cmci poll mode

Some (if not all) patches were authored by tglx but the single patch
emails are missing a "From:" line at the beginning of the mail
containing him as the author.

Please sort out who's the author of each patch and since it seems you
have a local git branch you're sending, git-commit has an --author
option with which you can fixup the authorship.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
