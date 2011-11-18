Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1KRSff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:35:35 -0500
Received: from mx2.netapp.com ([216.240.18.37]:54212 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab1KRSfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:35:34 -0500
X-IronPort-AV: E=Sophos;i="4.69,534,1315206000"; 
   d="scan'208";a="600072298"
Message-ID: <1321641333.2653.15.camel@lade.trondhjem.org>
Subject: Re: [PATCH] Add "-e" option to rpc.gssd to allow error on ticket
 expiry. Try 2 with added man pages.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: John Hughes <john@Calva.COM>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 18 Nov 2011 20:35:33 +0200
In-Reply-To: <4EC66D12.2090505@Calva.COM>
References: <4EC66D12.2090505@Calva.COM>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 18 Nov 2011 18:35:33.0742 (UTC) FILETIME=[DB6D00E0:01CCA620]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:34 +0100, John Hughes wrote: 
> Description: Add "-e" (ticket expiry is error) option to rpc.gssd
>   In kernels starting around 2.6.34 the nfs4 server will block all I/O
>   when a user ticket expires.  In earlier kernels the I/O would fail
>   with an EACCESS error.  This patch adds a "-e" option to rpc.gssd
>   which allow the earlier behaviour (EKEYEXPIRED is converted to
>   EACCESS).  This behaviour is particularly useful when user home
>   directories are nfs4 mounted with krb5 security - if the user is
>   absent from their workstation for long enough for the ticket to
>   expire a new ticket will be obtained (via pam_krb5) by the screen
>   unlock process.

You need a big fat warning somewhere that enabling this option WILL
cause data corruption...

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

