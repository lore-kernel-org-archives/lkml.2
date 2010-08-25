Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0HYTfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:35:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37532 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HYTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LD3dRzZiNghLETYxftGYjei+sDfo076tTyvGYyXNVwte6Jdvbcr88fYgDAWQfiRiE/
         us9K8qx1kFwcvJ8Tyq280TnHLOgL2UxQ3zUQYXuqfkTeqIMPK49ySkeTt0GmOqtoSV+V
         Jb+iBMn9s5NNbwBRd5vV8FwG07Au6EyZIhdG0=
MIME-Version: 1.0
In-Reply-To: <d58b966615c0a9978ec314ff1e5c53a7.squirrel@localhost>
References: <d58b966615c0a9978ec314ff1e5c53a7.squirrel@localhost>
Date: Wed, 25 Aug 2010 14:34:54 -0500
X-Google-Sender-Auth: cyYHknmWYJ0uLtLe3wQOh9cVDeg
Message-ID: <AANLkTi=porFYjmX57uNohLqwdszieyRSaEgVUhgH6z0j@mail.gmail.com>
Subject: Re: Allocating memory aligned on 1M boundary?
From: Timur Tabi <timur@freescale.com>
To: david.hagood@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 1:35 PM,  <david.hagood@gmail.com> wrote:

> Yes, I could allocate 2x the desired size, then use that part of what I
> allocate that is correctly aligned, but then I am guaranteed to waste half
> of what I allocate.

You can use the mechanism used in alloc_pages_exact() to free the
pages that you don't need.

-- 
Timur Tabi
Linux kernel developer at Freescale
