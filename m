Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0CRJrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:47:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0CRJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vzu9qYaPkBs7BavjP7X1LHgASw8pgkHZUIsap/v9KanukM7QfxrQeryhjxZnUFURVC
         FwiJVjwT9MMcq4L2C9Whp3js+v0zWqHmSU8SHLREqiVSZ73yGSUFgv7HuKA9fuD6az2o
         9vGFGq3CGMxHjvBXS5Zbybte1spM9cefbKf9Y=
MIME-Version: 1.0
In-Reply-To: <4BA1E03D.4050602@coyote.org>
References: <1268899193-16034-1-git-send-email-lindley@coyote.org>
	 <4BA1DE50.1080908@cs.helsinki.fi> <4BA1E03D.4050602@coyote.org>
Date: Thu, 18 Mar 2010 11:47:03 +0200
X-Google-Sender-Auth: be6e365ea3127646
Message-ID: <84144f021003180247p5d175606j25d4b41ddfda2587@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: mds_f.h whitespace corrections.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:11 AM, Lars Lindley <lindley@coyote.org> wrote:
> Sure..So Mds_SendComplete would be mds_send_complete?

Oh, I meant just the argument names. Functions are bit bigger impact
and I'd prefer to avoid it for now.
