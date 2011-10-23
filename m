Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1JWV0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:26:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1JWV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:26:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Xi0Q0zd0gw8xE5XJ29NUFQ/Xt+mPacL1wXjFBbxoYYJITWlClVAdQW3WTbx1Q6xOG
	3AjOBlhDkyhCzOidF9+UQ==
Date: Sun, 23 Oct 2011 14:26:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Norbert Preining <preining@logic.at>
cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
In-Reply-To: <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
References: <20111019124931.GC3963@gamma.logic.tuwien.ac.at> <1319038282.25023.21.camel@wwguy-ubuntu> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
 <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319119852.2111.2.camel@wwguy-ubuntu>
 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Norbert Preining wrote:

> > Great, this is just a test patch, we will figure out what is the correct
> > way to handle this and fix the issue for good :-)
> 
> Thanks. If you need more testing just let me know.
> 

It'd be interesting to see if this problem still exists in linux-next 
since some wireless changes went into that recently.  Please try the tree 
at git://github.com/sfrothwell/linux-next.git
