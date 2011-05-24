Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab1EXWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:32:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64350 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1EXWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P+jZqPZyEsho+5/m9QY0C5gi4swNSULXHUlfVDhS9mSdgQbynky6WCGrkNRhzQxIbR
         H2QciVEO0ff3RgpthJ49kiV/i7FwLTvaKxFhGQsnSi7tU04NF23Q1YYcZR3FBsuHfURS
         Ss/tI4ZXSoJTfow+HNpLQlUyeJUnx2iGTGWmc=
MIME-Version: 1.0
In-Reply-To: <20110524133204.GA11529@nb-core2.darkstar.lan>
References: <20110524133204.GA11529@nb-core2.darkstar.lan>
Date: Wed, 25 May 2011 07:32:05 +0900
Message-ID: <BANLkTinu_kUij0gj3RswwWahLwvOKoXiLg@mail.gmail.com>
Subject: Re: [PATCH] Delete unused variable no_wb.
From: Minchan Kim <minchan.kim@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:32 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> The number of writeback threads was removed from the output by c1955ce3.
>
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Good eye.
-- 
Kind regards,
Minchan Kim
