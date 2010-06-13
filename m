Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0FMTzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 15:55:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab0FMTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 15:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lb66j2uMnyhMp3KzgsTgdWbKCSYmcxFUJP5nwhIAH7Hvr4g+f1ae61beSY4Nqo95dG
         2YBZSA+6VmlBDxkgr2RjUxWcOkzgrmB6y47Pm6dQXJop8wzbhBkeL3FHETGGEdK0IBW6
         VjPF9bSnZUBlsLJEGfS3C8zj4VvHiXojl5gDw=
MIME-Version: 1.0
In-Reply-To: <20100613152348.GA1794@arch.tripp.de>
References: <20100613152348.GA1794@arch.tripp.de>
Date: Sun, 13 Jun 2010 21:55:40 +0200
Message-ID: <AANLkTinudiZQ9ZVi6nSBD-dkcEGXJhwYzt1tScTYn8eU@mail.gmail.com>
Subject: Re: read(2) hangs waiting for data from a closed socket
From: Alex Riesen <raa.lkml@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 17:23, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> Just revert commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837 for now.
> See also: http://lkml.org/lkml/2010/6/12/37

I see. Thanks! Reverting the commit indeed fixes the conky/hddtemp problem.
