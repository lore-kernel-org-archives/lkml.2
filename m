Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0KHGZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:25:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37649 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0KHGZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Fyna4XMitFtj1UOCTH++fMtjB79PP9MDHXuUSuF3arlMoOLstwsRgmEfd21W1fZamt
         iFce12EeHDp05efejDBK7o3z3nrgdJs7YNoD4jyqMdj1fIK3h3rY/us1/TknBeuwcL86
         RVibOoqX/BhsI7lpIVzwdcitJxXSTKdcs7i/Q=
Message-ID: <4CD79786.9000303@gmail.com>
Date: Mon, 08 Nov 2010 14:24:06 +0800
From: =?UTF-8?B?IlBldGVyIFBhbijmvZjljavlubMpIg==?= 
	<panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100324 RedFlag/3.0.1-1rf2.dt8 Thunderbird/3.0.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        =?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQ?= =?UTF-8?B?YW4pIg==?= 
	<wppan@redflag-linux.com>,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
References: <4CD75033.7080902@redflag-linux.com> <20101108043752.GB5563@bicker>
In-Reply-To: <20101108043752.GB5563@bicker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月08日 12:37, Dan Carpenter wrote:
> This is inside a loop and sometimes we do i++ and sometimes i--. Are
> you absolutely positive that path + i isn't initialized?
>
> I haven't followed this code through all the way but my instinct is
> that the memset is there for a reason.
>    
I know that I misunderstood it.

Thank you!

Regards

Peter Pan
