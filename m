Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1EHVpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:45:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63159 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab1EHVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nhW0MqeIwfzNWmwBlKjUkYkIFjDiLXgohhCPGcebsGfO1lrBjuR8hBv7Lb0qJOURY1
         zpXgOXZnYInLVImx3KlJOlKc7JPmjTEAjLC83AVae4ojEXLQQyaPq3RUgYxS8cXJZ4bH
         hznWHkl5EJjXDShbGv6Pn4N53Ea6IlOyywUWs=
MIME-Version: 1.0
In-Reply-To: <4DC70B45.3020503@redhat.com>
References: <20110508211834.GA4410@maxin>
	<4DC70B45.3020503@redhat.com>
Date: Mon, 9 May 2011 00:44:58 +0300
Message-ID: <BANLkTi=ksGXYBYx39xxQ51VZVT6u4ANq0g@mail.gmail.com>
Subject: Re: [PATCH] mm: memory: remove unreachable code
From: Maxin John <maxin.john@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, walken@google.com,
        aarcange@redhat.com, hughd@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
> Is it really impossible for vma->vm_ops->access to return a
> positive value?
>

Got it .. Thank you very much for pointing it out.

Best Regards,
Maxin
