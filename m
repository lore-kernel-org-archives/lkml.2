Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1AYNr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:47:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1AYNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:47:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fbzjgGGrB8DBRiL7TlI5mDlIoRTwho2Orb9+hszfm0R4CkdxvoY9UtJQrf2SCVdXsP
         ZUn5Xqj88OWW/Gsj9QRbFMq0o99P8Dg13C8+alL7C+UqPbNPqy33EIaUsD4qoMnnSbnT
         76uzNNRNFCbrg+3yey2sPKkI5MK+An5jTWrKE=
Date: Tue, 25 Jan 2011 14:47:22 +0100
From: Tejun Heo <tj@kernel.org>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 01/32] arm/omap: use system_wq in mailbox
Message-ID: <20110125134722.GZ27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-2-git-send-email-tj@kernel.org>
 <AANLkTimMK2Ec8SQiRyRBR+MdVKhAmMaaf+oa0VK3wWsf@mail.gmail.com>
 <20110104052421.GD6748@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104052421.GD6748@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:24:21AM +0100, Tejun Heo wrote:
> Using dedicated workqueue or system_wq doesn't make any difference in
> terms of execution latency anymore.  Sleeping work items no longer
> delay execution of other work items.  If mailbox is very latency
> sensitive, it might make sense to create a HIGHPRI workqueue but that
> usually isn't necessary.

Ping.  Shall I apply the patch?

Thanks.

-- 
tejun
