Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab1ETPzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:55:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62331 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab1ETPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PiA8mOijre8Jzz0sKNk37WNixYHUU/l4gm5rCQUlkDwj2lZvhNZaFi7VIZ9T4VY2jl
         T4mZSmFN9QQUdAFDIYg+hdk6b1eQM9oVnjPm7KwWCEtxrHgxEPWrjwH6NuZZ7SqRvnp7
         e60QCxXEHH/hxKgCTwQIvaImSHrzOQBwlWhFM=
MIME-Version: 1.0
In-Reply-To: <20110520152118.GA10699@oksana.dev.rtsoft.ru>
References: <20110219150644.681D59D401D@zog.reactivated.net>
	<AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
	<20110520152118.GA10699@oksana.dev.rtsoft.ru>
Date: Fri, 20 May 2011 16:55:33 +0100
X-Google-Sender-Auth: GHkpkbFLqLi8kPzCljYrX9ru-i8
Message-ID: <BANLkTikkqF_0xe2BVkDn0JOr9jcG_SPFbw@mail.gmail.com>
Subject: Re: [PATCH] olpc_battery: bind to device tree
From: Daniel Drake <dsd@laptop.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2011 16:21, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> I just wondering what happened with this patch?..

I sneakily posted it for review "prematurely" :)

I have a corrected version based upon all received feedback, but this
patch actually depends on another patch (for x86 tree) which has been
submitted and resubmitted and is still awaiting review:

http://marc.info/?l=linux-kernel&m=130416849500918&w=2

Haven't forgotten, but thanks for the reminder :)

Daniel
