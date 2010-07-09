Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0GINAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:00:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0GINAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:00:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
Date: Fri, 9 Jul 2010 15:00:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
       linux-security-module@vger.kernel.org
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278595102.3313.36.camel@localhost.localdomain> <alpine.LRH.2.00.1007090852200.23354@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1007090852200.23354@tundra.namei.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091500.29138.arnd@arndb.de>
X-Provags-ID: V02:K0:NvDSF8jAIBjyenQ7uJOfILqAUm491zH+aInhIDnJyCs
 R9xPUfwUqZ3vhhgdKdTeJoq5X7Wk8GYqYrn6r7DdZlOhKdZFEv
 3SQi1Cx959eKlFaY2Wce69aEBJ1UAJTzFmqe1Gu16WHNopqDMI
 oYfmPM6YFXu79PnnPeU8Yt+Q35En8tArkoWEU8oaaKZFNl6DoS
 uLEAEqF/C7uBJy/+FcuVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 July 2010, James Morris wrote:
> On Thu, 8 Jul 2010, Mimi Zohar wrote:
> > 
> > I'll leave that up to James.
> 
> I can take the patches, depends on what Arnd thinks is best.

I'd prefer you to take it. I'll work out with Frederic what we
do with the remaining patches, but ideally all maintainer
should just take their bits from this series, there are no
interdependencies except for the last two patches.

	Arnd
