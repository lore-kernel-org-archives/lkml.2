Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1DHOhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:37:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34081 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1DHOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sDHT3NDukYls3UQ5VMZ1UDl5ZNiP5jQphejccpqJdMAoKFZ+2VmpGB9P06qSe1ws5l
         pQ5YlrIRFs2hWlbTElAg==
MIME-Version: 1.0
In-Reply-To: <4D9CE4AE.4090303@zytor.com>
References: <4D9CE4AE.4090303@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 8 Apr 2011 08:36:45 -0600
Message-ID: <BANLkTinT=UoVCwwEcpfPvCCL-e-Zh0r1qw@mail.gmail.com>
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 4:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi all,
>
> At Linus' request, I have modified the tip-bot to recognize a new form
> of email archive references, which should work as clickable links.
> Instead of:
>
> LKML-Reference: <message-id>
>
> use, instead:
>
> Link: http://lkml.kernel.org/r/message-id

Really cool idea.  I assume you'll mention this in
Documentation/SubmittingPatches or somewhere similar.

Bjorn
