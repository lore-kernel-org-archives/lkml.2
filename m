Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1LHLIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:08:34 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:44261 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1LHLIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:08:31 -0500
Date: Thu, 8 Dec 2011 12:08:27 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 3/4] xen: Add xenbusd device driver
Message-ID: <20111208110827.GA32300@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Ian Campbell <Ian.Campbell@citrix.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
 <1323292396-19523-4-git-send-email-waldi@debian.org>
 <1323332686.2969.49.camel@zakaz.uk.xensource.com>
 <20111208092757.GA22678@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111208092757.GA22678@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 10:27:58AM +0100, Bastian Blank wrote:
> I even think about registering this device from xenstored_local_init in
> xenbus_probe.c. Then it will be available only if the kernel also owns
> the communcation ring.

I'm not sure if I'm allowed to register character devices from a
postcore_initcall. Isn't this function called a bit early anyway?

Bastian

-- 
Each kiss is as the first.
		-- Miramanee, Kirk's wife, "The Paradise Syndrome",
		   stardate 4842.6
