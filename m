Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2DBO6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:58:15 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:47588
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751628Ab2DBO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:58:13 -0400
Date: Mon, 2 Apr 2012 16:58:12 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
In-Reply-To: <1333378674.22146.18.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1204021655430.29393@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>       <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>      <1330531826.3545.128.camel@sauron.fi.intel.com>      <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
   <1332511796.18717.72.camel@sauron.fi.intel.com>     <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>    <1332521515.22278.2.camel@sauron.fi.intel.com>    <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>   
 <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>   <1332837188.31549.14.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>  <1333377383.22146.14.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net>
 <1333378674.22146.18.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I guess I was a little confused WRT iv vs cryptokey. Anyway, I thought
> you just use UBIFS_CRYPTO_KEYSIZE for all of this, why not to just use
> the constant in this function? Why passing the length as an argument?
>

There's no actually reason... in my head, if I have a char buffer then the
next parameter is its length. I'll change it so the comments discuss the
length of the buffer.
