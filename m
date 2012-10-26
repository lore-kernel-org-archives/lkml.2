Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965897Ab2JZSTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:19:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36160 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965556Ab2JZSTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:19:41 -0400
Date: Fri, 26 Oct 2012 19:19:05 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121026181904.GA5770@srcf.ucam.org>
References: <20121023145920.GD16496@redhat.com>
 <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
 <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
 <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
 <1351274374.18115.205.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351274374.18115.205.camel@falcor>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:59:34PM -0400, Mimi Zohar wrote:
> On Fri, 2012-10-26 at 03:39 +0100, Matthew Garrett wrote:
> > and it must be impossible for anything other than 
> > /sbin/kexec to make the kexec system call.
> 
> Permission is a MAC issue. :)

It's a MAC issue that has to be implemented in the kernel. We can't 
depend on userspace loading any kind of policy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
