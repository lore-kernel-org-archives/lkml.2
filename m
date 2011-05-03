Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1ECQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:26:16 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50748 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1ECQ0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=ORejZa26ZKy1UEuWqTdVpMWYkE2gLFjkKemjL5CyP7dJONlxvbY1SXlSZaAtSD+gBN
         w9bkGnfFepdehpBgeGiFDQ7fIq9bt0C9YiVKGkbuoUzJLYcZQFDGeravlrBHk0wWpOlp
         zIcQkLA+S2/MmDx12U7BY7Y2bf6slr+yPkRpg=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110503152139.GU1762@opensource.wolfsonmicro.com>
References: <1304435704.2591.18.camel@phoenix> <20110503152139.GU1762@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 4 May 2011 00:25:54 +0800
Message-ID: <BANLkTi=ExpYXGPRUjFaNzjYxthkPydvhRg@mail.gmail.com>
Subject: Re: [PATCH] regulator: Remove mc13xxx_unlock in regulator_register
 failure path
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,
> This feels painful, we shouldn't have to be faffing about with the lock
> like this for basic I/O operations.  It feels like we should be pushing
> the lock down into the register access functions - looking at the driver
> I can't really see any reason why all this stuff is being done by hand,
> especially when we've got explicit read/modify/write bitmask operations.
>

Agreed. Thanks for the review. I'll send a patch for it.

Regards,
Axel
