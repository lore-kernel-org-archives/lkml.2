Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1KVOci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:32:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:54828 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1KVOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:32:37 -0500
Date: Tue, 22 Nov 2011 09:32:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ANNIE LI <annie.li@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        Kurt Hackel <Kurt.Hackel@oracle.com>
Subject: Re: Forth version patches for upstreaming grant table version 2
Message-ID: <20111122143220.GB3430@phenom.dumpdata.com>
References: <4ECB77BB.9090401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB77BB.9090401@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4ECBB280.0061,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 06:21:47PM +0800, ANNIE LI wrote:
> Hi
> 
> The following patches introduce and implement grant table version 2.
> This is the forth version patches, and based on v3.2.0-rc1+. Changes
> from the previous patches are following:
> 
> * Fix an indentation issue of the code.

I've put your patches in my queue for 3.3. They should show up in my #linux-next
tonight if there are no outstanding compile/test issues.
