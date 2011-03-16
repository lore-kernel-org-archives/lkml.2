Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1CPPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:32:19 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42488 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752967Ab1CPPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:32:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c3xhqXhwZ92TjEyuQPK8fhEZBXSw1q6DxCuztjMEOzBSfeG31c5/EkPL6m2IRdpecBhU/G8BdIlP55nrwNoPlhjP184fwUUkPNav4r6E598GsupENcla3nJyqmbtBICP;
Date: Wed, 16 Mar 2011 08:32:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <ijc@hellion.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
Message-ID: <20110316083205.405910ac@jbarnes-desktop>
In-Reply-To: <alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
	<20110304104251.45b257c4@jbarnes-desktop>
	<1299595858.17339.512.camel@zakaz.uk.xensource.com>
	<1299601032.17339.525.camel@zakaz.uk.xensource.com>
	<alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 12:34:10 +0000
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> Jesse,
> do you have any comments on the following patch?
> Also, are you OK with taking "set current_state to D0 in register_slot"
> in your tree? Otherwise should I send a pull request to Linus with the
> patch and your ack?

Yeah, I think the patch is ok, I can send it to Linus either as part of
my 2.6.39 pull req (though it's probably too late for that) or in my
next -fixes pull.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
