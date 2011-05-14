Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab1ENUZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:25:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ENUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c0uGbDzSCPaHGWR0+5qZXhzew2HsK2os4fgm9yNYrhZe8dBVNUIcp2jC8Iz6s9L/o6
         ITTylbYGmXEbAnil7n0Q==
MIME-Version: 1.0
In-Reply-To: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
References: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
Date: Sat, 14 May 2011 13:24:57 -0700
Message-ID: <BANLkTikVWes5LAV9Gj7GfH=rCrc3EtYx4g@mail.gmail.com>
Subject: Re: [PATCH v2] tmpfs: implement generic xattr support
From: Hugh Dickins <hughd@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Suchanek <hramrach@centrum.cz>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 4:16 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [This update addresses comments from Hugh and Andrew]

Acked-by: Hugh Dickins <hughd@google.com>
