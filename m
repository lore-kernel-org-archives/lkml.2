Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2JAN2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:28:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28326 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2JAN2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:28:30 -0400
Date: Mon, 1 Oct 2012 15:28:15 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, andrew.cooper3@citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] x86/xen: Register resources required by kexec-tools
Message-ID: <20121001132815.GF2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <20120928162132.GC16262@localhost.localdomain>
 <50698111020000780009EB2E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50698111020000780009EB2E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:40:01AM +0100, Jan Beulich wrote:
> >>> On 28.09.12 at 18:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Thu, Sep 27, 2012 at 08:06:32PM +0200, Daniel Kiper wrote:
> >> +	for (i = 0; i < cpus; ++i) {
> >
> > Any specific reason for using '++i' instead of 'i++' ?
>
> For people occasionally also writing C++ code this is the
> canonical form.

Heh... I have not written any C++ code since the end
of my C++ course at my university (~18 years).
I am just prefer '++i' instead of 'i++'.
That is it.

Daniel
