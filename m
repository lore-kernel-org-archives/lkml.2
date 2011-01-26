Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1AZKkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:40:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38918 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1AZKkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SfszGxyGLhV+bBdl5Yze+XK01jFF8PVtcNFpSAY66wNGuLB/pqi+Bqx+sw+0+l/xL1
         5GmnwxP0KC5P4lx+YyxnUYz1wzfJgnEYCnJzwqweIADM7OejqvrL3NeCBnfM3q+/68EN
         +JaC6SFutIfevLppYBEWpvLotIiTdiT1rP+Zk=
Date: Wed, 26 Jan 2011 11:40:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: update workqueue users - replace
 create_workqueue()
Message-ID: <20110126104008.GG12520@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <20110125142921.GB27510@htj.dyndns.org>
 <20110125162654.GA4795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125162654.GA4795@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:26:54AM -0500, Dave Jones wrote:
> On Tue, Jan 25, 2011 at 03:29:21PM +0100, Tejun Heo wrote:
>  > Hello,
>  > 
>  > There was no response for the following patches and I'm planning on
>  > routing them through workqueue#for-2.6.39.  If you have an objection
>  > or want to take the patch through a different tree, please let me
>  > know.
>  > ..
>  >  0007-cpufreq-use-system_wq-instead-of-dedicated-workqueue.patch
> 
> Feel free to add my 
> Signed-off-by: Dave Jones <davej@redhat.com> 
> to this.
> 
> I looked it over, and didn't see anything objectionable.

As the patch is going through wq tree, I added Acked-by instead of
Signed-off-by.

Thank you.

-- 
tejun
