Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab1CUPxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:53:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1CUPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qGCm3HwwaCcpuLs9NXS7lX94zRTEd8bf3tp2YpJaSnrWvrm/vPI8S6O01Lh0EgwZhg
         u0jMuHT9mYIVc3VvcA0zpkpeUO/Pq+mUWb8Yz4tfXfsSdvUjoKHpk8fIpb2H12Q8cdn5
         PS0Sj5sabU1tUSjYfEcF7ATKNHLJY46YH/CSk=
Date: Mon, 21 Mar 2011 18:52:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] rapidio: potential null deref on failure path
Message-ID: <20110321153609.GR2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110319044032.GC2008@bicker>
 <0CE8B6BE3C4AD74AB97D9D29BD24E55201A588F5@CORPEXCH1.na.ads.idt.com>
 <20110321145948.GP2008@bicker>
 <0CE8B6BE3C4AD74AB97D9D29BD24E55201A5897F@CORPEXCH1.na.ads.idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201A5897F@CORPEXCH1.na.ads.idt.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:15:33AM -0700, Bounine, Alexandre wrote:
> In this case I agree. 
> Do you want me to move this patch up or you have your own path for it?
> 

Could you take it, please? 

regards,
dan carpenter


