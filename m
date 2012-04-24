Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2DXQEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:04:10 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:4238 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755Ab2DXQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:04:09 -0400
Message-ID: <1335283446.1469.6.camel@t41.thuisdomein>
Subject: Re: [PATCH] [RFC] TPM: be silent if disabled or deactivated
From: Paul Bolle <pebolle@tiscali.nl>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 18:04:06 +0200
In-Reply-To: <20120424144708.GA29206@localhost.br.ibm.com>
References: <1334223857.2439.5.camel@x61.thuisdomein>
	 <20120424144708.GA29206@localhost.br.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.0.1 (3.4.0.1-1.fc18) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Apr 2012 16:04:07.0971 (UTC) FILETIME=[E126DF30:01CD2233]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 11:47 -0300, Rajiv Andrade wrote:
> [...], we do want to trigger this as an error in case a faulty
> hardware claims to be functional after the tpm_do_selftest(), but decides
> to return this error code when already registered. I'll modify
> tpm_do_selftest() to handle these two scenarios. 

If you think your patch needs some testing (against v3.3.x) feel free to
send something my way.

By the way, would anyone know whether a patch that suppresses unneeded
error messages qualify for stable (once it is in Linus' tree, of
course)?


Paul Bolle

