Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0FWPpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:45:01 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52825 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753411Ab0FWPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:44:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ek/K0i1gIv9dGiR3N1q/JdJ+RsokJUHB2HhZn+Nm3bMwtjBH527jqhWgaKt01/10fSclpA8aKjNHxUIvDFlnMsJYdFuPzyQoRtK8yn+rayDsSqEniVeIJid+XnLH7Zcs;
Date: Wed, 23 Jun 2010 08:43:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt/console: try harder to print output when panicing
Message-ID: <20100623084305.033df51e@virtuousgeek.org>
In-Reply-To: <1277262779-19338-1-git-send-email-airlied@gmail.com>
References: <1277262779-19338-1-git-send-email-airlied@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 13:12:59 +1000
Dave Airlie <airlied@gmail.com> wrote:

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Jesse's initial patch commit said:
> 
> "At panic time (i.e. when oops_in_progress is set) we should try a bit
> harder to update the screen and make sure output gets to the VT, since
> some drivers are capable of flipping back to it.
> 
> So make sure we try to unblank and update the display if called from a
> panic context."
> 
> I've enhanced this to add a flag to the vc that console layer can set
> to indicate they want this behaviour to occur. This also adds support
> to fbcon for that flag and adds an fb flag for drivers to indicate
> they want to use the support. It enables this for KMS drivers.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---

Yeah this looks a little nicer, thanks.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
