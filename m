Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1E0N6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:58:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42101 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1E0N6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XJouq8jJCuOM+s2NZ1Saizbip+OB0eqqcyJQMoCJK/wSIfNZ9XCseRh79BtdMta9b+
         vwuOYC53YSTiYz08RXA2IBfRNBE1ileYZaAdUH9k9aul5N+2EnWQ5RBwTAzlLMCizWjE
         gRS1fKFc2LQv4u+Jb8j5TcmuRMe1EA0w/F164=
MIME-Version: 1.0
In-Reply-To: <20110527131237.GA27647@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com> <20110527131237.GA27647@infradead.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 27 May 2011 09:57:41 -0400
X-Google-Sender-Auth: ye43qvBErSlqX1wj0Hy8Wga4yTE
Message-ID: <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
To: Christoph Hellwig <hch@infradead.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 9:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 27, 2011 at 10:11:22PM +0900, Namhyung Kim wrote:
>> Since BARRIER requests have been converted to FLUSH/FUA, it would be
>> better for blktrace to recognize FLUSH requests as BARRIER for the
>> backward-compatibility IMHO.
>
> I'd rather see new flags for them.  F and U maybe?

Somehow I'm not surprised by your F and U suggestion -- appropriate on
multiple levels :)
