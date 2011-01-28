Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1A1Np6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 08:45:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59329 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1A1Np5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 08:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bPoEZhq8TeZ7cVGA6EfTnspPNkj7GiCpJZTnLNyTaUVD+GabJbeDfbfeFMQeG+g7Ol
         ybZcACap833ky4wyScx4ngNfuiJqLe21r8Uvz17L03MqA1oIEQcWRJr7qr3C+18HWr5X
         0h1rDzloWttsPjTaMj+ZbBFoWv8dvqvn/+0Ek=
Date: Fri, 28 Jan 2011 14:45:49 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, penberg@kernel.org, shaohui.zheng@intel.com,
        rientjes@google.com
Subject: Re: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#5
Message-ID: <20110128134549.GK24925@htj.dyndns.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295789862-25482-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 02:37:26PM +0100, Tejun Heo wrote:
> This is the fifth take of unify-x86_32-and-64-NUMA-init-paths
> patchset.

hpa, ping?

Thanks.

-- 
tejun
