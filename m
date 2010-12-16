Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0LPM6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:58:23 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45731 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0LPM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:58:19 -0500
X-Greylist: delayed 48771 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 07:58:19 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xIaElwdL/cdy2NnxAK1OB9D4NG+gPwK/TFK9/ZBIre9Cajih99yAZ49stbk4UBY4IZ
         zuL4S4DCSaeq6bkBkFU5AzgI79kQkoPW8zXhBtAcvKkD8zEDdOAHl2JYw10vI/LHKHfH
         8v9LbmT54jrmW0Vb42ODxMJQuQT3RF25iBYdE=
MIME-Version: 1.0
In-Reply-To: <20101215235312.GA15328@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
	<AANLkTikuWubUkGp2nESWTLz+kQsczznh7fuixdLzMfdO@mail.gmail.com>
	<20101215221454.GB6560@dtor-ws.eng.vmware.com>
	<AANLkTindv4GUp3E8Vzkzm_JzGxxOP+TdaAsVhxrEVOw6@mail.gmail.com>
	<20101215235312.GA15328@dtor-ws.eng.vmware.com>
Date: Thu, 16 Dec 2010 14:58:18 +0200
Message-ID: <AANLkTikVku4u6jm6Um+pCAZbxrQo7vuaE+S3qjsY3XAJ@mail.gmail.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 1:53 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> Yeah, I hate to disappoint them but it will break as soon as someone
> adds a module_param() to one of the objects... That's even without my
> changes.

Yeah, it should have been renamed to /sys/tristate :-\
