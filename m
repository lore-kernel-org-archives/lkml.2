Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1ECWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:41:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1ECWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ub/+sG9ersuEX2M8f/EQ2U6oMVNjMWIGM+8vzxEYG9M2KgXb+z4YMb9sxcCEgwgA00
         E+lL23VpWWmhAeLy2lXA==
MIME-Version: 1.0
In-Reply-To: <BANLkTinqHNCzcZmQL6M-pCszTmPO=-X8yw@mail.gmail.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
 <1304124773-24935-1-git-send-email-vnagarnaik@google.com> <20110503131820.GB23498@redhat.com>
 <BANLkTinqHNCzcZmQL6M-pCszTmPO=-X8yw@mail.gmail.com>
From: Michael Rubin <mrubin@google.com>
Date: Tue, 3 May 2011 15:41:14 -0700
Message-ID: <BANLkTik4N_cWuw2Vq65UX5jCW+AccQHAHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Change trap definitions to enumerated values
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 12:00 PM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> Would it make better sense to separate this patch into 2 patches, the first
> one replacing the numbers to enums and the second one adding the tracepoints?

Yes please do that.
Each patch should stand on its own with one simple purpose if possible.

mrubin
