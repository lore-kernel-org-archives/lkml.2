Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2H0VCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:02:35 -0400
Received: from nm32-vm8.bullet.mail.gq1.yahoo.com ([98.136.216.231]:20424 "HELO
	nm32-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754403Ab2H0VCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:02:32 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 17:02:32 EDT
X-Yahoo-Newman-Id: 118102.70087.bm@smtp201.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FJggNNQVM1l_8BsKcuYSzIVWd.sNjn2FDa6XeX6JUOX57EJ
 LOzIYsMUn_r0BsYsfL_kZXlHkqWMiA7H7LL4hwyPF9S58mtSyutHRBsx.ONB
 LXSKiJpPcJq6NxcaCdhc1bUOE0yD0_rYNjLKu5WH4kDGFQkIR4rwSfblayXs
 5k561P4WE9QYQCGmmVmzeZtCVpwl89KkneYUa15dERKUVnVhIHyEF3enDmyw
 v3FyVsjerCcXywWYE9pxjSiEMFfK9Og4ASjuAhgzcoxyNgOWKVZ0GXdzwg_E
 XUXFPm6FcRwETmbnik1L2eqTbepq8L559DIM5svcj6Uk7qJMcUUmWzj9lNLC
 JpQyj9LrtzS2p55xDEcpk0iH34yqEsx3NcF.4xEjd2m7juaWkGH10sPlLNOE
 _.i6kpkW4gdv.PUtb0pnL_srjcVSnbRGPW46H1iVDONKK4BKb9UMRKL6S
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Mon, 27 Aug 2012 15:57:08 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [BUG]: fsnotify oops on 3.5.2
Message-ID: <20120827205706.GA18063@ymail.com>
References: <20120826204453.GA10707@ymail.com>
 <20120827053201.GB27551@yanx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827053201.GB27551@yanx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 01:32:01PM +0800, Guo Chao wrote:
> Problematic instruction seems to be this one:
> 
>    85 73 74             	test   %esi,0x74(%ebx)

Guo:

Thank you very much for the very detailed response on the meaning of the
oops - it was very educational for me. I did have one question, however.
How were you able to identify the relevant section in the source code?

> But have no idea how 'struct path' contained a NULL 
> 'struct vfsmount *' ... ...
> 

As Steven points out, this could be a bug in the overlayfs code. After
getting a 2nd oops last night, I rebuilt 3.5.2 w/o overlafs in order to
test that theory. Though I am unable to reproduce at will, 2 oopses in
60 hours suggests I should not have to wait too long for a verdict.

I will follow-up in a couple of days one way or the other.

~ Andy
