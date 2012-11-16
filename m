Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2KPPHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:07:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2KPPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:07:12 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cPT-bUsLaBUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=eJptcAyAPSAA:10 a=BK5COI1aXy1v8h95-CAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353078429.7586.15.camel@gandalf.local.home>
Subject: Re: [PATCH] staging: Add SystemBase Multi-2/PCI driver
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, hjchoi <hjchoi@sysbas.com>
Date: Fri, 16 Nov 2012 10:07:09 -0500
In-Reply-To: <20121116145851.GA20180@kroah.com>
References: <1353040771.7586.2.camel@gandalf.local.home>
	 <20121116050807.GA13122@kroah.com>
	 <1353071875.7586.5.camel@gandalf.local.home>
	 <20121116133255.GA30683@kroah.com>
	 <1353076129.7586.10.camel@gandalf.local.home>
	 <20121116145851.GA20180@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 06:58 -0800, Greg Kroah-Hartman wrote:
> On Fri, Nov 16, 2012 at 09:28:49AM -0500, Steven Rostedt wrote:
> > On Fri, 2012-11-16 at 05:32 -0800, Greg Kroah-Hartman wrote:
> > 
> > > Redo this aginast 3.7-rc5 and we should be better off.  If you really
> > > want to do this right, do this against the tty-next git tree, to catch
> > > all of the recent tty changes that will be going into 3.8.
> > 
> > I did it against linux-next commit:
> 
> Much better, that worked, now applied.

Note, I only compiled tested that version, as the box that has my card
in it is my main workstation. Not something I run test kernels on. Yeah,
I'm lame :-)

-- Steve


