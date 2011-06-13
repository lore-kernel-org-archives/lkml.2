Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab1FMK1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:27:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33165 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1FMK1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=SDizua/c9SOKLI7Sq5UcFQrk0ZyrCKgpVTnWKc1dDRqDbWYmgwzEzzQBvxLtSKl1fY
         UrgjdYBl34rC+TTXqMzNho1Ds5Ld4Hx/xWGrL2KstlElrPE8VBJGxmL7iWDRSnuS6MZh
         U5Q8CMloMZ8ooVv8F81vyDskhimJSv/DHTHzQ=
Date: Mon, 13 Jun 2011 18:26:57 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, jkosina@suse.cz
Subject: Re: [PATCH resend] Documentation:fix the wrong file dereference in
 Documentation
Message-ID: <20110613102654.GA5165@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, jkosina@suse.cz
References: <1307958833-6213-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1307958833-6213-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 05:53:53PM +0800, Wanlong Gao wrote:
> Hi Jiri:
> I had fix the wrong dereference all in these files,
> and resend this patch, it'll be OK?
> 
> Thanks
> 
> 
> Change all "arch/i386" to "arch/x86" in Documentaion/,
> since the directory has changed.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>

Thanks
Harry Wei
