Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0IEIsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:48:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41639 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0IEIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=j5OCdqV+UqTQ/RXtilNk9rOyYYv4snAR2uzoAXqNPG8JVQPhQBQgwWooTYKA4zH5Ic
         Vk0MTMUYLBPMR2eXHq3Kaq9PwB5hLDnyP+/UtJt8aT6YweQRE/5Vm2qKCMeYldQXcNjp
         /UgyHzaMKDzdtItMBnNSSgeQRLE+boJ9czMk8=
MIME-Version: 1.0
In-Reply-To: <20100905044902.GA3130@kroah.com>
References: <1283595045-6922-1-git-send-email-pshah.mumbai@gmail.com> <20100905044902.GA3130@kroah.com>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Sun, 5 Sep 2010 14:17:54 +0530
Message-ID: <AANLkTimY86oAsYsZBseszgXgvDEOCYN=iD67r5fwG95_@mail.gmail.com>
Subject: Re: [PATCH] Staging: xgifb: fixed many style issues in XGI_accel.c
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, apatard@mandriva.com,
        randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Um, I think you forgot to build this patch, it dies a horrible death.
>
> Please always test your patches before sending them out.
>

Missed a } on line 2134

Rechecked all the patches and sent a updated patch.

> thanks,
>
> greg k-h
>
