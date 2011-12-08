Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1LHLJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:09:24 -0500
Received: from smtp.citrix.com ([66.165.176.89]:40165 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1LHLJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:09:23 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320642000"; 
   d="scan'208";a="19774090"
Message-ID: <4EE09AE1.3080703@citrix.com>
Date: Thu, 8 Dec 2011 11:09:21 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 0/4] V2, Move stuff out of xenfs
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 21:13, Bastian Blank wrote:
> In<20100605162947.GA31336@wavehammer.waldi.eu.org>  I started the
> discussion about xenfs and the usage of it. This is the second try to
> move stuff over into normal device drivers.

You still don't say why this is needed in the commit messages.  I can't
find the message you refer to in the previous thread (the mail archives
don't let you search by message-id).

David
