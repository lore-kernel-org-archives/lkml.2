Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0HCRbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:31:55 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:49522 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab0HCRby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:31:54 -0400
X-ASG-Debug-ID: 1280856712-642d00030000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C585287.80806@fusionio.com>
Date: Tue, 3 Aug 2010 19:31:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jan Harkes <jaharkes@cs.cmu.edu>, "coda@cs.cmu.edu" <coda@cs.cmu.edu>,
        "stable@kernel.org" <stable@kernel.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>,
        "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>
X-ASG-Orig-Subj: Re: [PATCH] coda: rename REQ_* to CODA_REQ_*
Subject: Re: [PATCH] coda: rename REQ_* to CODA_REQ_*
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org> <4C57FA57.2000601@kernel.dk> <4C57FBAD.1080809@fusionio.com> <4C583B3B.3060301@kernel.org> <4C583DAD.4080507@kernel.org>
In-Reply-To: <4C583DAD.4080507@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1280856712
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 18:02, Tejun Heo wrote:
> REQ_* constants are used for block layer requests causing inconsistent
> duplicate definitions of REQ_WRITE.  Rename REQ_* used by coda to
> CODA_REQ_*.

Should have been clear, I committed the fixup already:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=ceb1fde0d5c7611fdb9004176ac34140d27e745a

Looks byte-for-byte identical :-)

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
