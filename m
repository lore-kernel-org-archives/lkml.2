Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab0IXORe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:17:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47580 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0IXORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=UKEVvq7pspBATWyi2oFOo3bF+/WxciMrtPwKtrZBJcLEgoogwhoOL1YwM2Mzpy75tB
         XQff+lD5GMiW7wX1cMyMGYNwRzqJQ1kHkAT+AWD7ne5YjJDAjVjkji2TDwTQe6OhsqTl
         ibM8JDc/Oiyn3K8S1tJKd6fAXh99CebusKbmg=
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100924140943.GB1551619@jupiter.n2.diac24.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1hbhgq1v1.fsf@fess.ebiederm.org> <1285240926.5036.7.camel@bigi>
	 <20100923145856.GB1160234@jupiter.n2.diac24.net>
	 <1285329084.13976.661.camel@bigi>
	 <20100924125704.GA1551619@jupiter.n2.diac24.net>
	 <1285335173.13976.693.camel@bigi>
	 <20100924140943.GB1551619@jupiter.n2.diac24.net>
Content-Type: text/plain
Date: Fri, 24 Sep 2010 10:16:58 -0400
Message-Id: <1285337818.13976.697.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 16:09 +0200, David Lamparter wrote:

> I understood your point. What I'm saying is that that functional graph
> you're describing is too simplistic do be a workable model. Your graph
> allows for what you're trying to do, yes. But your graph is not modeling
> the reality.

How about we put this specific point to rest by agreeing to
disagree? ;->

> Err... I'm migrating netdevs to assign them to namespaces to allow them
> to use them? Setup, basically. Either way a device move only happens as
> result of some administrative action; be it creating a new namespace or
> changing the physical/logical network setup.
> 

Ok, different need. You have a much more basic requirement than i do.

> wtf is a "remote" namespace?
> 

A namespace that is remotely located on another machine/hardware ;->

> Can you please describe your application that requires moving possibly
> several network devices together with "their" routes to a different
> namespace?

scaling and availability are the driving requirements.

cheers,
jamal

