Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2CIHPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:15:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:36835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab2CIHPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:15:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126886874"
Message-ID: <1331277476.22872.2.camel@sauron.fi.intel.com>
Subject: Re: [patch] Add encryption key parameter to compress/decompress
 functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Mar 2012 09:17:56 +0200
In-Reply-To: <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <1329152067.22240.214.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 16:29 +0100, Joel Reardon wrote:
> This patch extends to interface for compression and decompression of data 
> nodes to take a cryptographic key
> as a parameter. If it is set to NULL, then the current behaviour persists. 
> If it is non-null, then it is taken
> as a pointer to an array of length UBIFSEC_KEYSIZE (=16 bytes) which 
> contains the key to use to encrypt
> the data node. Each data node should be encrypted with a separate key as 
> it uses the same initialization vector  (of 0).

This patch is also wrapped... Would you consider using git - commit your
patches, then git format-patch, then git send-email them - git tools
will take everything right. Use --dry-run with git send-email first to
check everything is right.

-- 
Best Regards,
Artem Bityutskiy

