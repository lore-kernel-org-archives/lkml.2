Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0I0VlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:41:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46260 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0I0VlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=rtmlq7I4zjGcLXAZypfagslDsh1ljnL5wm0WcylzvGJKuWNq5ngXgM85LKU9zF+CjI
         4DFCBxOCVKaa9tqH4OrWM1snmx+oiuHrrymKw1AOdNjS9v7TTQM85evZXb0Wy1GZTtp5
         0/XEWNBK95dW3X7LOvZVF/1EEp50qyjY6x+kk=
MIME-Version: 1.0
In-Reply-To: <20100927120641.6B3F.A69D9226@jp.fujitsu.com>
References: <AANLkTimKZdD1DjymuhwKCtrraK2QwBOw5XUo0HBnQPKv@mail.gmail.com>
	<20100927120641.6B3F.A69D9226@jp.fujitsu.com>
Date: Mon, 27 Sep 2010 16:40:59 -0500
Message-ID: <AANLkTiknh_oVCtaUzcH8rh5XdORm-Pb83z22_zPB_4pO@mail.gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
From: William Immendorf <will.immendorf@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 10:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This is a backport of Upstream commit e31f3698cd3499e676f6b0ea12e3528f569c4fa3.
>> Originally submitted by Wu Fengguang. The rest of the message is his.
>> I think this would be a good canadate for the stable tree.
>
> We already did :)
I really meant for this patch to reach the stable tree. KOSAKI, can
you please email the stable tree mantianer and tell him to put this
patch in a 2.6.35.7 stable quere? (and also tell me the stable commits
address for refrence.)


-- 
William Immendorf
The ultimate in free computing.
Messages in plain text, please, no HTML.
GPG key ID: 1697BE98
If it's not signed, it's not from me.

--------------

"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
