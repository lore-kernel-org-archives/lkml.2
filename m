Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2KCPN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:13:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2KCPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:13:27 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1FDNxFMC7OYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zNXoGfytzK0A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=ZAH4KCEHR5VkbgX2vy8A:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351955605.4004.159.camel@gandalf.local.home>
Subject: Re: [ 0/4] 3.0.51-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Sat, 03 Nov 2012 11:13:25 -0400
In-Reply-To: <20121103144340.GA1383@kroah.com>
References: <20121102170333.581931288@linuxfoundation.org>
	 <20121103003108.GA1981@optiplex.redhat.com>
	 <20121103040711.GD1602@kroah.com>
	 <20121103114501.GA1688@optiplex.redhat.com>
	 <20121103144340.GA1383@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 07:43 -0700, Greg Kroah-Hartman wrote:
> On Sat, Nov 03, 2012 at 09:45:02AM -0200, Rafael Aquini wrote:
> > On Fri, Nov 02, 2012 at 09:07:11PM -0700, Greg Kroah-Hartman wrote:
> > > > 
> > > > Howdy Greg,
> > > > 
> > > > Somehow the following patch is missing for this series submission:
> > > > > Len Brown <len.brown@intel.com>
> > > > >     x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
> > > > 
> > > > I glanced at the the downloadable consolidated patch and its hunks seem to be present,
> > > > though.
> > > 
> > > I do not understand.  Where do you not see it?  It's in the patch on
> > > kernel.org, right?  Where is it missing?
> > > 
> > 
> > The LKML patch series is missing PATCH 02/04.
> 
> Odd, I received a copy, but I don't know if it came from lkml or as a
> copy sent to me directly.  I'll bounce it to you if you are curious
> about it.
> 

Yeah, 2/4 is missing. Probably had too many Cc's. I really wish David
Miller would remove that limit. I bet it's kept more legitimate emails
from making LKML than it has spam.

I know I've been burnt by it a few times :-/

-- Steve


