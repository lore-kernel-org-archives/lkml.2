Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab2GMTBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:01:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2GMTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:00:59 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=iMP0YAry9DcA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=7EYnarjUgzTT3snX5MEA:9 a=CjuIK1q_8ugA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Fri, 13 Jul 2012 15:00:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        KY Srinivasan <kys@microsoft.com>, Greg KH <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Message-ID: <20120713190057.GA16873@home.goodmis.org>
References: <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004193414.GA15672@suse.de>
 <4FFFF711.8040003@redhat.com>
 <426367E2313C2449837CD2DE46E7EAF9223B57EC@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <50001F71.9070806@redhat.com>
 <20120713132441.GD10298@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713132441.GD10298@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 03:24:43PM +0200, Borislav Petkov wrote:
> On Fri, Jul 13, 2012 at 03:15:29PM +0200, Paolo Bonzini wrote:
> > Il 13/07/2012 15:13, KY Srinivasan ha scritto:
> > >> > 
> > >> > Somone was trying to be funny, I guess.
> > >> > 
> > >> > KY, I suppose you have access to Hyper-V code or can ask someone who does.
> > >> > Is this signature actually used in the Hyper-V host code?
> > > It is still early in the morning here and pardon me if I am not seeing the issue.
> > 
> > [offlist]

I guess not :-)

> > 
> > 0xB16B00B5 = big boobs
> 
> LOL! You can't make this stuff up!
> 

I guess that's why it's in a file called hyPERV_vmbus. ;-)

-- Steve

