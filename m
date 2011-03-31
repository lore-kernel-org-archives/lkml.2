Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab1CaWLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:11:06 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:32063 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759364Ab1CaWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:11:04 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares (bisected)
Date: Thu, 31 Mar 2011 15:11:01 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc6+; KDE/4.5.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com> <201103311019.52073.dtor@vmware.com> <4D94CDBC.4010000@netapp.com>
In-Reply-To: <4D94CDBC.4010000@netapp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311511.02070.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 31, 2011 11:53:48 am Bryan Schumaker wrote:
> Hi
> 
> If you apply this patch, does it fix the problem?

Yes, it does!

Thank you for your help.

-- 
Dmitry
