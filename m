Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0JZOc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:32:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0JZOcZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 26 Oct 2010 10:32:25 -0400
Date: Tue, 26 Oct 2010 10:31:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 3/5] xen: events: push setup of irq<->{evtchn,pirq}
 maps into irq_info init functions
Message-ID: <20101026143156.GC9557@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
 <1288023813-31989-3-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288023813-31989-3-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 05:23:31PM +0100, Ian Campbell wrote:

The description and title aren't really that descriptive. Could you
redo it a bit, please?
