Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0KTDAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 22:00:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab0KTDAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 22:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CqF6Wp+x163sui7iVLazUWjUL7eVvng0yb08rQ7BOb7VRZ8KIkYsQmXuewr+X7UsSE
         HIRwbUstvnPFqZiPvTsikGQt4CZegC/C628K55KN1ZVIMYiyVvi/CwPyKg2TGQiMePqK
         ApP05/ZluZJABnp6osn0gQe7a0d+nFwCP1Pus=
Message-ID: <4CE739A6.6070306@gmail.com>
Date: Fri, 19 Nov 2010 18:59:50 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ide boot failure 2.6.36/2.6.28 - 2.6.27 works
References: <20101120021515.GA3277@iq>
In-Reply-To: <20101120021515.GA3277@iq>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 06:15 PM, Andries E. Brouwer wrote:
> In case anybody is still interested in this old IDE stuff:
> I wanted to boot a recent kernel on an old machine and failed.
> The last kernel that worked was 2.6.27.
> What goes wrong is that the disks are no longer detected on 2.6.28.
> I see that 2.6.28 had a lot of changes in this area.
> Maybe this just needs a new boot option I overlooked.
> (Or is oldfashioned IDE considered broken these days?)
>
> Google gives me many people with the same problem
> (e.g., http://bugs.gentoo.org/253628) but no remedy.
> I have not looked at the code yet.
>
> Andries
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


probably best to bisect if you can..

Justin P. Mattock
