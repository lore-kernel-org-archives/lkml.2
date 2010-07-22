Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0GVUla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:41:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:58237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab0GVUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:41:26 -0400
Message-ID: <4C48ACE6.4090303@kernel.org>
Date: Thu, 22 Jul 2010 22:41:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH wq#for-next] workqueue: fix how cpu number is stored in
 work->data
References: <4C46CEA3.7040503@in.ibm.com>	<4C4718D5.1080902@kernel.org>	<20100722112557.14b65077@mschwide.boeblingen.de.ibm.com>	<4C4838B8.1080400@kernel.org> <20100722171028.2aa0b8f2@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100722171028.2aa0b8f2@mschwide.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 20:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 05:10 PM, Martin Schwidefsky wrote:
> Compiles and boots for s390. Thanks.

Added Tested-by's and applied to wq#for-next.

Thanks.

-- 
tejun
