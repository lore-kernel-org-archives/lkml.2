Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab1CaRTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:19:54 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:38441 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758710Ab1CaRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:19:53 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares (bisected)
Date: Thu, 31 Mar 2011 10:19:51 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc6+; KDE/4.5.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com> <20110331165035.GA6778@dtor-ws.eng.vmware.com> <4D94B6BD.3010409@netapp.com>
In-Reply-To: <4D94B6BD.3010409@netapp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311019.52073.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 31, 2011 10:15:41 am Bryan Schumaker wrote:
> Thanks for the log and extra info.  What setting does the server use to
> export /toolchain?  You can usually find this in /etc/exports, but it
> may be different for NIS.  I would like to set up my NFS server in a
> similar way so I can try to reproduce what you're seeing.
> 

Bryan,

Unfortunately I do not have shell access to the NFS server. I can only 
provide data that can be collected from the client.

[dtor@dtor-ws linus]$ showmount --exports build-toolchain
Export list for build-toolchain:
/apps      *
/trees     *
/toolchain *

Thanks,
Dmitry
