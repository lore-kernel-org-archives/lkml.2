Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1KVObm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:31:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36599 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab1KVObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:31:41 -0500
Date: Tue, 22 Nov 2011 09:31:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ANNIE LI <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 3/4] xen/granttable: Grant tables V2 implementation
Message-ID: <20111122143123.GA3430@phenom.dumpdata.com>
References: <4ECA416D.90602@oracle.com>
 <1321927161-3987-1-git-send-email-annie.li@oracle.com>
 <1321954186.3664.403.camel@zakaz.uk.xensource.com>
 <4ECB7324.9080008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB7324.9080008@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ECBB249.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 06:02:12PM +0800, ANNIE LI wrote:
> 
> 
> On 2011-11-22 17:29, Ian Campbell wrote:
> >On Tue, 2011-11-22 at 01:59 +0000, annie.li@oracle.com wrote:
> >[...]
> >>+#ifdef CONFIG_X86
> >>+		barrier();
> >>+#else
> >>+		mb();
> >>+#endif
> >>+		}
> >Niggle: Indentation of this final } is off.
> Sorry, I did not notice that.
> >Otherwise all 4 patches:
> >Acked-by: Ian Campbell<ian.campbell@citrix.com>
> >
> >[...]
> Thanks, I will resend those patches after above indentation issue is fixed.

That is OK. I can modify them.
> 
> Thanks.
> 
> Thanks
> Annie
