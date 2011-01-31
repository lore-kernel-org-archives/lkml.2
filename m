Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1AaNms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:42:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1AaNmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:42:47 -0500
Subject: Re: [RFC -v7 PATCH 5/7] export pid symbols needed for
 kvm_vcpu_on_spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <4D46B88C.4000700@redhat.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
	 <20110126172303.3d5184a7@annuminas.surriel.com>
	 <1296474699.15234.396.camel@laptop>  <4D46B88C.4000700@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 Jan 2011 14:43:35 +0100
Message-ID: <1296481415.26581.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 15:26 +0200, Avi Kivity wrote:
> On 01/31/2011 01:51 PM, Peter Zijlstra wrote:
> > On Wed, 2011-01-26 at 17:23 -0500, Rik van Riel wrote:
> > >  Export the symbols required for a race-free kvm_vcpu_on_spin.
> >
> > Avi, you asked for an example of why I hated KVM as a module :-)
> 
> Why do you dislike exports so much?

Because I hate modules [*], since we sadly cannot undo those, limiting
the module interface is all we've got, and KVM is one that pushes the
module interface further and further.

Many people see an EXPORT as a acknowledgement that its OK to use the
interface, even when its not.

[*] they enable the binary junk thing.
