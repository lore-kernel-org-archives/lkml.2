Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0ENVs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:48:57 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:47328 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab0ENVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wq9hMFauZPC9pRHJWdrsjJ1vcbqFOUdlGOBsLJk1xsXyX08GrkuftRTCLxGOATiMUC
         t0yQ81XLF+qmnGb6b8mOUnM225/a+xPLdZVxcx9RasOcBNUI2jpvXytYLxUvDuPhhdhu
         +uzSavqZYfW4UWsqgb/rEC2C0ZckqBv+orAK4=
Message-ID: <4BEDC53C.8040107@garzik.org>
Date: Fri, 14 May 2010 17:48:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jamie Lokier <jamie@shareable.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       lkml <linux-kernel@vger.kernel.org>,
       DE/ATA development list <linux-ide@vger.kernel.org>,
       saeed bishara <saeed.bishara@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [BUG] bug when enabling VM DEBUG
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com>	 <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>	 <4BEA1559.9000107@gmail.com>	 <1273662639.23818.67.camel@e102109-lin.cambridge.arm.com>	 <20100512115340.GA11261@Chamillionaire.breakpoint.cc>	 <1273667099.23818.86.camel@e102109-lin.cambridge.arm.com>	 <20100512130638.GB19314@shareable.org> <1273750233.30713.39.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1273750233.30713.39.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 07:30 AM, Catalin Marinas wrote:
> I already proposed a PIO cache flushing API on linux-arch. I tried to
> revive the discussion with another patch for cachetlb.txt but it hasn't
> drawn much interest.


Oh well.  I'll apply the local-to-libata patch, and hope that someone 
else proposes a better API.

	Jeff



