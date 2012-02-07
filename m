Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2BGUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:54:36 -0500
Received: from ozlabs.org ([203.10.76.45]:46889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab2BGUye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:54:34 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
In-Reply-To: <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org> <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 08 Feb 2012 03:43:01 +1030
Message-ID: <87zkcuh8iq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 08:59:00 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> On Mon, Feb 6, 2012 at 3:51 AM, James Morris <jmorris@namei.org> wrote:
> > On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:
> >
> >> Hi,
> >>
> >> Here is another module verification patchset, which is based on the recently
> >> upstreamed digital signature support used by EVM and IMA-appraisal.
> >
> > You should cc: Rusty on any changes to the module code.
> >
> 
> Hello,
> 
> Mimi already has pointed that out.
> I have sent him an email with the link..

Thanks.

Using an external signature (via cmdline arguments) is simple, at
least.  Not sure what the userspace side of this looks like?

Cheers,
Rusty.
