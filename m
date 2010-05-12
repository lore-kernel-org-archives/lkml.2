Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0ELTKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:10:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47533 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0ELTKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ulLccDJK/XuZuVtGJ67uBFuXwtDxSfM+3O08M7yqtU+tXjkAkwIlGQrXjoabsVKKYy
         AHmp4KwWCQbV8jL3ldyGulJqV9niKVEksizheQmCyqi/bic2Ylp65TrIirrIMfdv34LE
         gfoI/51Z6GZs4KrYXOMVUZzgwFr12trTQIE3o=
MIME-Version: 1.0
In-Reply-To: <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
Date: Wed, 12 May 2010 21:10:42 +0200
Message-ID: <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 9:01 PM, Paul Menage <menage@google.com> wrote:
> What about the case where some subset of the parent's mems/cpus are
> given to a child with the exclusive flag set?
>

As I mentioned in the TODO, it is still to be handled. But it should
simply exclude those mems/cpus which are exclusive. It was a bit more
involved than the effort I wanted to put in before gauging the
reactions.

Thanks!
Dhaval
