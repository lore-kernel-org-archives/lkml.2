Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1LGOTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:19:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58826 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1LGOTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:19:02 -0500
Message-ID: <1323267521.4009.11.camel@lappy>
Subject: Re: [PATCH 1/2] KVM: VMX: Notify if VMX is already in use
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Date: Wed, 07 Dec 2011 16:18:41 +0200
In-Reply-To: <4EDF7590.5060701@redhat.com>
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
	 <4EDF7590.5060701@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 16:17 +0200, Avi Kivity wrote:
> On 12/01/2011 08:30 PM, Sasha Levin wrote:
> > Currently we silently fail if VMX is already in use by a different
> > virtualization technology.
> >
> > This is bad since it's non-obvious for the user, and its not too uncommon
> > for users to have several of these installed on same host.
> >
> > This patch adds a message to notify the user of the problem.
> >
> 
> Does this actually happen?  With which hypervisor?

vbox

It turns VMX/SVM on when it loads, regardless of whether it's running a
guest or not.

-- 

Sasha.

