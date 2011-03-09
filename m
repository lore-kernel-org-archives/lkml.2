Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1CIGd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:33:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46907 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1CIGdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ov35IbIDWtGEaABMIHKMwjxuHfhmtRLA3WZgNPyCTbPAWViblN7OBL8vKzZw1hnwM9
         M06MdxeSWlNLSF+ELLcIaPlG+CheoaESkvM0xKKopythUmCjQDMtDqGwvsmn4MsNYE64
         Pj64XDwZW4488rX+kSYFLioeXU3isK4TyOmN0=
Date: Wed, 9 Mar 2011 14:33:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 2/2] hpsa: export resettable_on_kexec host attribute
Message-ID: <20110309063339.GB16951@cr0.redhat.com>
References: <20110308230749.22291.56200.stgit@beardog.cce.hp.com>
 <20110308231003.22291.20417.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308231003.22291.20417.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 05:10:03PM -0600, Stephen M. Cameron wrote:
>From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
>This attribute, requested by Redhat, allows kexec-tools to know
>whether the controller can honor the reset_devices kernel parameter
>and actually reset the controller.  For kdump to work properly it
>is necessary that the reset_devices parameter be honored.  This
>attribute enables kexec-tools to warn the user if they attempt to
>designate a non-resettable controller as the dump device.
>
>Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Maybe we should docment this sysfs attribute somewhere?

Thanks.
