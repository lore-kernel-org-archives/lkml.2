Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906Ab2KAPLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:11:01 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:52060 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761791Ab2KAPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:11:00 -0400
Message-ID: <1351782656.3782.58.camel@rhapsody>
Subject: Re: Kdump with signed images
From: Khalid Aziz <khalid@gonehiking.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, kexec@lists.infradead.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        horms@verge.net.au, "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Dave Young <dyoung@redhat.com>
Date: Thu, 01 Nov 2012 09:10:56 -0600
In-Reply-To: <20121101145731.GB10662@srcf.ucam.org>
References: <1351190421.18115.92.camel@falcor>
	 <20121025185520.GA17995@redhat.com> <1351214158.18115.186.camel@falcor>
	 <20121026023916.GA16762@srcf.ucam.org> <20121026170609.GB24687@redhat.com>
	 <1351276649.18115.217.camel@falcor> <20121101131003.GA14573@redhat.com>
	 <20121101135356.GA15659@redhat.com> <1351780159.15708.17.camel@falcor>
	 <20121101145149.GB15821@redhat.com> <20121101145731.GB10662@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 14:57 +0000, Matthew Garrett wrote:
> On Thu, Nov 01, 2012 at 10:51:49AM -0400, Vivek Goyal wrote:
> 
> > And if one wants only /sbin/kexec to call it, then just sign that
> > one so no other executable will be able to call kexec_load(). Though
> > I don't think that's the requirement here. Requirement is that only
> > trusted executables should be able to call kexec_load().
> 
> Where "trusted executables" means "signed by a key that's present in the 
> system firmware or in the kernel that's signed with a key that's present 
> in the system firmware", sure.
> 

This is starting to sound too restrictive (even though I understand the
rationale behind the restrictions). Does this allow for a custom
userspace application that among other things also can kexec_load() a
new kernel and boot it, for example a customer unique health monitoring
app that reboots the system if things are not looking right on the
running system? How would a customer go about getting that userspace
binary signed and re-signed every time they update their app? There is
the option of turning the whole SecureBoot thing off for a system like
that but let us assume customer wants to leave that on or does not have
the option to turn it off?

--
Khalid

