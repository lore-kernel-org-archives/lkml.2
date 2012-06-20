Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2FTXJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:09:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39145 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758298Ab2FTXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:09:00 -0400
X-Sasl-enc: 8+LoXEiEjAYeofbQwDFqw52XWmKmsyf/x2hHo/wW+OQE 1340233739
Date: Wed, 20 Jun 2012 20:08:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620230856.GA4223@khazad-dum.debian.net>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340182778.21745.75.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 01:28 +0200, Borislav Petkov wrote:
> > which makes me wonder whether we still need that OLD INTERFACE.
> > Henrique, any thoughts here? 
> 
> Yes I need it, I've no f'ing clue where to put the ucode image so that
> the whole firmware mess can find it :-)

iucode_tool -K <name of intel microcode .dat/.bin file(s)> will do it
for you :p

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
