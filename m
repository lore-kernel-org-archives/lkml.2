Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1JTFar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:30:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1JTFao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:30:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=L8zCkiRif2ohnjl4W23lwjVEoNCYmWK3XtZAkk0rbkVz3AmkLaxg1fDLg+CF+mo/6
	tDVZyASbB/YIqbVnX4p4w==
Date: Wed, 19 Oct 2011 22:30:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Norbert Preining <preining@logic.at>
cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
In-Reply-To: <20111020031421.GS11060@gamma.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.00.1110192230140.4618@chino.kir.corp.google.com>
References: <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
 <1319038282.25023.21.camel@wwguy-ubuntu> <20111020020225.GO11060@gamma.logic.tuwien.ac.at> <1319074339.31823.68.camel@wwguy-huron> <20111020025123.GR11060@gamma.logic.tuwien.ac.at> <E9954878DD1FB34FAE5187FB88C58A3501A0D0992E@orsmsx506.amr.corp.intel.com>
 <20111020031421.GS11060@gamma.logic.tuwien.ac.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Norbert Preining wrote:

> No attachment again ... something is filtering here???
> 
> Please include it directly in the email
> 

Not sure why you're not receiving the inlined patch, you can see it at 
https://lkml.org/lkml/2011/10/19/505
