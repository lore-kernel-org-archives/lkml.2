Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031075Ab2B2OlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:41:12 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39253 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030947Ab2B2OlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:41:11 -0500
Date: Wed, 29 Feb 2012 15:40:54 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229144054.GH21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com>
 <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E3059.7040004@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:04:09AM -0300, Mauro Carvalho Chehab wrote:
> No, you didn't. Every time i touch on this point, you just say that it
> doesn't fit without giving any explanation why not.

Let me explain it to you one _last_ time:

- severity: No real need for it. If the error is severe enough, the
kernel handles automatically, i.e. memory poisoning and recovery. In all
the other cases it is not severe enough.

- location: this is contained in the ->cpu field.

- silkscreen_label: <sarcasm> yeah, I'm getting a, say, a Data
Cache error during an L1 linefill from L2, what the f*ck does the
silkscreen label mean for such an error?! Well, nobody knows wtf it
means!</sarcasm>

- error_msg: already there in my patch.

So go and read and try _understanding_ this before you come back with
more crap, ok?

> Running away from this discussion won't help at all.

Not running away - trying not to waste time with bullshit.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
