Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2BCCjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:39:44 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57419 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322Ab2BCCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:39:43 -0500
Message-ID: <1328236778.18641.75.camel@joe2Laptop>
Subject: Re: [PATCH 3/6] drivers: hv: Cleanup the kvp related state in
 hyperv.h
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Thu, 02 Feb 2012 18:39:38 -0800
In-Reply-To: <20120202234848.GA26647@kroah.com>
References: <1327708522-26914-1-git-send-email-kys@microsoft.com>
	 <1327708562-26964-1-git-send-email-kys@microsoft.com>
	 <1327708562-26964-3-git-send-email-kys@microsoft.com>
	 <20120202232936.GA9614@kroah.com>
	 <6E21E5352C11B742B20C142EB499E0481B70927D@TK5EX14MBXC128.redmond.corp.microsoft.com>
	 <20120202234848.GA26647@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 15:48 -0800, Greg KH wrote:
> On Thu, Feb 02, 2012 at 11:41:29PM +0000, KY Srinivasan wrote:
> > > > +#define __packed __attribute__((packed))
[]
> > When I ran the checkpatch script against these patches I got a warning that the
> > preferred directive was to use "__packed".
> Well, checkpatch is stupid sometimes.

True.

I suppose checkpatch warning could be improved to
say that it's preferred for "kernel only" files
and should be ignored for public/user cases.


