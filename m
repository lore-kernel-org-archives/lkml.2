Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965901Ab2JZS2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:28:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54333 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965556Ab2JZS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:28:20 -0400
Message-ID: <1351275954.18115.209.camel@falcor>
Subject: Re: Kdump with signed images
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Date: Fri, 26 Oct 2012 14:25:54 -0400
In-Reply-To: <20121026181904.GA5770@srcf.ucam.org>
References: <20121023145920.GD16496@redhat.com>
	 <87fw552mb4.fsf_-_@xmission.com> <20121024173651.GE1821@redhat.com>
	 <1351145401.18115.78.camel@falcor> <20121025141048.GD9377@redhat.com>
	 <1351190421.18115.92.camel@falcor> <20121025185520.GA17995@redhat.com>
	 <1351214158.18115.186.camel@falcor> <20121026023916.GA16762@srcf.ucam.org>
	 <1351274374.18115.205.camel@falcor> <20121026181904.GA5770@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102618-5806-0000-0000-00001B136F2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 19:19 +0100, Matthew Garrett wrote:
> On Fri, Oct 26, 2012 at 01:59:34PM -0400, Mimi Zohar wrote:
> > On Fri, 2012-10-26 at 03:39 +0100, Matthew Garrett wrote:
> > > and it must be impossible for anything other than 
> > > /sbin/kexec to make the kexec system call.
> > 
> > Permission is a MAC issue. :)
> 
> It's a MAC issue that has to be implemented in the kernel. We can't 
> depend on userspace loading any kind of policy.

Still a MAC issue, that problably could be addressed by capabilities.  I
suggest you post this issue on the LSM mailing list.  Please cc: Serge,
as the capabilities maintainer.

thanks,

Mimi

