Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2JBNpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:45:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39655 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2JBNpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:45:32 -0400
Date: Tue, 2 Oct 2012 15:46:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jamie Gloudon <jamie.gloudon@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20121002134602.GA5015@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jamie Gloudon <jamie.gloudon@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com
References: <20121001161151.GA2640@darkstar>
 <20121001162745.GD23181@x1.osrc.amd.com>
 <20121001233704.GA1344@darkstar>
 <20121002043954.GA27331@liondog.tnic>
 <20121002131138.GA1387@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121002131138.GA1387@darkstar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 09:11:38AM -0400, Jamie Gloudon wrote:
> My main interest was getting PEBS events support for perf on Intel SNB
> cpus. Loading the microcode at runtime was not going to work.
>
> However, thanks for pointing me in the right direction. I notice today
> this is not the case anymore from the thread below.
>
> http://marc.info/?l=linux-kernel&m=133905353211963&w=2

Yes, there's a perf callback from within the ucode driver to recheck
PEBS. This is in 3.6 so PEBS should work there with the required ucode
patch.

-- 
Regards/Gruss,
Boris.
