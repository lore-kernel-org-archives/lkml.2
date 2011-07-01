Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1GAI2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:28:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:38023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1GAI17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:27:59 -0400
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <4E0D369C.4090403@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-8-git-send-email-glommer@redhat.com>
	 <1309470869.12449.607.camel@twins>  <4E0D369C.4090403@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Jul 2011 10:26:31 +0200
Message-ID: <1309508791.12449.631.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 23:53 -0300, Glauber Costa wrote:
> On 06/30/2011 06:54 PM, Peter Zijlstra wrote:
> > On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
> >> +       if (static_branch(&paravirt_steal_enabled)) {
> >
> > How is that going to compile on !CONFIG_PARAVIRT or !x86 in general?
> > Only x86-PARAVIRT will provide that variable.
> >
> >
> 
> Good point. I'd wrap it into CONFIG_PARAVIRT.
> To be clear, the reason I did not put it inside 
> CONFIG_PARAVIRT_TIME_ACCOUNTING, is because I wanted to have the mere 
> display of steal time separated from the rest - unless, of course, you 
> object this idea.
> 
> Using CONFIG_PARAVIRT achieves this goal well.

ia64 seems to also have CONFIG_PARAVIRT
