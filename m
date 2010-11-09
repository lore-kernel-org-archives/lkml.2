Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0KIQs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:48:57 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34684 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab0KIQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:48:54 -0500
X-Sasl-enc: nMKPzUVFOKqjcbbeFKJmxoTAmSLFon/BYhIG4YBfrFb/ 1289321333
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
Date: Tue, 9 Nov 2010 17:46:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.5.2; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com> <201011091702.58449.roberto.sassu@polito.it> <1289319910.16976.52.camel@localhost.localdomain>
In-Reply-To: <1289319910.16976.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091746.38822.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010 05:25:10 pm David Safford wrote:
> On Tue, 2010-11-09 at 17:02 +0100, Roberto Sassu wrote:
> 
> > i want to inform you i've created a set of utilities for the creation of
> > trusted and encrypted keys which also works with the TrustedGRUB software:
> > for instance the new "trk_create" tool generates or updates a trusted key
> > passing the pcrinfo structure relative to the future configuration
> > by performing the same extend operations done by TrustedGRUB during the
> > boot process:
> ...
> > I have tested these tools using the Fedora 13 operating system and they may be of interest
> > if the TrustedGRUB part is not yet implemented by your tools. 
> > 
> > Roberto
> 
> My tools don't yet do the future boot pcr calculation,
> so this is wonderful. Are they available?
>

Sorry, actually they are not yet available. I have a plan to release them soon,
after doing some extra checks on the code.
I will sent a email here to announce the availability of the package on our server. 

Roberto

 
> dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
