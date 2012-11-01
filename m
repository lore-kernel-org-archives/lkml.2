Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095Ab2KAP5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:57:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:41568 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810Ab2KAP5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:57:38 -0400
Date: Fri, 2 Nov 2012 02:57:56 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, benh@kernel.crashing.org,
        adlai@linux.vnet.ibm.com
Subject: Re: [PULL] IBM vTPM driver update
In-Reply-To: <20121031170405.GA26935@ennui.austin.ibm.com>
Message-ID: <alpine.LRH.2.02.1211020256520.22272@tundra.namei.org>
References: <20121030211613.GA15631@ennui.austin.ibm.com> <alpine.LRH.2.02.1211010255350.12284@tundra.namei.org> <20121031170405.GA26935@ennui.austin.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Kent Yoder wrote:

> > >   git://github.com/shpedoikal/linux.git tpmdd-v3.7-rc3
> > 
> > I get massive merge conflicts pulling this into my -next branch.
> 
>   I applied it to your master, I was hoping this could get in before 3.7
> is released. Is this the right way to go about this?

Nope, my 'master' tracks Linus.

Use the -next branch.

See http://kernsec.org/wiki/index.php/Kernel_Repository





-- 
James Morris
<jmorris@namei.org>
