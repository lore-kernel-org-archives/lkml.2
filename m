Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1EFR27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:28:59 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:56942 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1EFR26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:28:58 -0400
X-ASG-Debug-ID: 1304702937-03d6a50f3637bb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DC42FD6.8010508@fusionio.com>
Date: Fri, 6 May 2011 11:28:54 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ricwheeler@gmail.com" <ricwheeler@gmail.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for  non-queueable
 flush drive
References: <20110505015932.306763905@sli10-conroe.sh.intel.com> <20110505020417.817084678@sli10-conroe.sh.intel.com> <20110505083853.GC30950@htj.dyndns.org> <1304656325.3828.22.camel@sli10-conroe> <20110506065347.GA8824@htj.dyndns.org>
X-ASG-Orig-Subj: Re: [patch v3 2/3] block: hold queue if flush is running for  non-queueable
 flush drive
In-Reply-To: <20110506065347.GA8824@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1304702937
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.62961
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-06 00:53, Tejun Heo wrote:
> Jens, can you please queue this for the next merge window?

Yep I will, I'll mark it as a backport as well.

-- 
Jens Axboe

