Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2LJO3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:29:37 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1259 "EHLO
	smtp-out-245.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2LJO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:29:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1617
Message-ID: <50C5F1CE.30402@metafoo.de>
Date: Mon, 10 Dec 2012 15:29:34 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: John Linn <John.Linn@xilinx.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: fetch failure the xilinx tree
References: <20121209162442.15fbb8509569c193bfd88986@canb.auug.org.au>
In-Reply-To: <20121209162442.15fbb8509569c193bfd88986@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2012 06:24 AM, Stephen Rothwell wrote:
> Hi John,
> 
> Attempting to fetch the xilinx tree produces this error (and has for some
> days, now):
> 
> fatal: The remote end hung up unexpectedly
> 

They renamed the repository from linux-2.6-xlnx to linux-xlnx. I stumbled
over it as well.

- Lars
