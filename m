Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0LHW4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:56:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:44514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab0LHW4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:56:45 -0500
Message-ID: <4D000D09.3060506@kernel.org>
Date: Wed, 08 Dec 2010 23:56:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Christoph Lameter <cl@linux.com>,
        William Hubbs <w.d.hubbs@gmail.com>, Dan Carpenter <error27@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/speakup: fix buildfailure by removing odd closing
 parenthesis
References: <1291848306-31620-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1291848306-31620-1-git-send-email-peterhuewe@gmx.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 22:56:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 11:45 PM, Peter Huewe wrote:
> Fix a simple buildfailure by removing an odd closing parenthesis
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Already fixed in percpu#for-next.  Sorry about the trouble.

Thanks.

-- 
tejun
