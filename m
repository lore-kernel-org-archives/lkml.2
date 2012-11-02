Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab2KBQ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:57:55 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:36441 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234Ab2KBQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:57:54 -0400
Message-ID: <1351875469.25914.51.camel@rhapsody>
Subject: Re: Kdump with signed images
From: Khalid Aziz <khalid@gonehiking.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, horms@verge.net.au,
        Dave Young <dyoung@redhat.com>, kexec@lists.infradead.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 02 Nov 2012 10:57:49 -0600
In-Reply-To: <20121101162315.GA13132@srcf.ucam.org>
References: <1351214158.18115.186.camel@falcor>
	 <20121026023916.GA16762@srcf.ucam.org> <20121026170609.GB24687@redhat.com>
	 <1351276649.18115.217.camel@falcor> <20121101131003.GA14573@redhat.com>
	 <20121101135356.GA15659@redhat.com> <1351780159.15708.17.camel@falcor>
	 <20121101145149.GB15821@redhat.com> <20121101145731.GB10662@srcf.ucam.org>
	 <1351782656.3782.58.camel@rhapsody> <20121101162315.GA13132@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 16:23 +0000, Matthew Garrett wrote:
> On Thu, Nov 01, 2012 at 09:10:56AM -0600, Khalid Aziz wrote:
> > How would a customer go about getting that userspace binary signed and 
> > re-signed every time they update their app? There is the option of 
> > turning the whole SecureBoot thing off for a system like that but let 
> > us assume customer wants to leave that on or does not have the option 
> > to turn it off?
> 
> There's ongoing work for providing mechanisms for trusting user keys. If 
> you want Secure Boot turned on, you don't want any untrusted code 
> running in your kernel. If you're happy with untrusted code in your 
> kernel, why are you using Secure Boot?
> 

I would argue code written by a customer to run on their own systems is
inherently trusted code and does not invalidate need/desire for Secure
Boot. So the customer will still need some way to get their binary
signed very painlessly just so they could use their own binary on their
own system, simply because of a heavily locked down system design by
Linux community.

--
Khalid

